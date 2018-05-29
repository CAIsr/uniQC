function this = load(this, inputDataOrFile, varargin)
% loads (meta-)data from file(s), order defined by loopDimensions
%
%   Y = MrDataNd()
%   Y.load(varargin)
%
% This is a method of class MrDataNd.
%
% IN
%   inputDataOrFile     can be one of 5 inputs
%                       1)  a Matrix: MrDataNd is created along with a
%                           dimInfo matching the dimensions of the data
%                           matrix
%                       2)  a file-name: MrDataNd is loaded from the
%                           specified file
%                       3)  cell(nFiles,1) of file names to be concatenated
%                       4)  a directory: All image files in the specified
%                           directory
%                       5)  a regular expression for all file names to be
%                           selected
%                           e.g. 'folder/fmri.*\.nii' for all nifti-files
%                           in a folder
%
%   varargin:   propertyName/value pairs, e.g. 'select', {'t', 1:10, 'z', 20}
%               for any property of MrDataNd and
%
%   select      for efficient loading of a data subset, a select of
%               values per dimension can be specified (corresponding to
%               dimInfo)
%
% OUT
%   this        MrDataNd with updated .data and .dimInfo
%   affineGeometry
%               For certain file types, the affineGeometry is saved as a
%               header information. While ignored in MrDataNd, it might be
%               useful to return it for specific processing
%               See also MrImage MrAffineGeometry
%
% EXAMPLE
%   load
%
%   See also MrDataNd demo_save
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2016-10-21
% Copyright (C) 2016 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3.
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: load.m 513 2018-05-27 08:41:04Z sklein $

if nargin < 2
    inputDataOrFile = this.get_filename();
end
defaults.select = [];
defaults.dimInfo = [];

[args, argsUnused] = propval(varargin, defaults);

% argsUnused could be a full dimInfo or properties of dimInfo as prop/vals
% pairs
% dimInfo = MrDimInfo(argsUnused);
% -> calls dimInfo.parse_propval_varargin(argsUnused)
%   - parses for dimInfo -> sets properties!
%   - parses prop/val pairs afterwards for additional updates

% dimInfo properties explicitly given as args to constructor?
% assuming argsUnused are properties of properties, e.g., for dimInfo: dimLabels etc.
loadInputArgs = {};
if ~isempty(argsUnused)
    nArgs = numel(argsUnused)/2;
    hasFoundPropDimInfo = false;
    tempDimInfoArgs = {};
    tempDimInfo = MrDimInfo();
    for iArg = 1:nArgs
        
        currProp = argsUnused{iArg*2-1};
        currVal = argsUnused{iArg*2};
        
        if isprop(tempDimInfo, currProp)
            hasFoundPropDimInfo = true;
            tempDimInfoArgs = [tempDimInfoArgs {currProp} {currVal}];
        else
            loadInputArgs = [loadInputArgs {currProp} {currVal}];
        end
    end
    
    % if anything was updated by params, it has to be stored!
    if hasFoundPropDimInfo
        % if no nSamples is given, assume at least 2 per dim, such that
        % resolutions etc. can be expressed
        if ismember('nSamples', tempDimInfoArgs(1:2:end))
            % all good
            args.dimInfo = MrDimInfo(tempDimInfoArgs{:});
        else % add nSamples
            tempNSamples = 2.*ones(size(tempDimInfoArgs{2}));
            args.dimInfo = MrDimInfo(tempDimInfoArgs{:}, ...
                'nSamples', tempNSamples);
        end
    end
end

strip_fields(args);

if ~isempty(dimInfo) % explicit dimInfo given
    this.dimInfo = dimInfo;
elseif exist(this.get_filename('dimInfo'), 'file')
    this.dimInfo.load(this.get_filename('dimInfo'));
    dimInfo = this.dimInfo.copyobj();
end

isMatrix = isnumeric(inputDataOrFile) || islogical(inputDataOrFile);

if isMatrix
    this.read_matrix_from_workspace(inputDataOrFile);
else
    
    isExplicitFileArray = iscell(inputDataOrFile) && ischar(inputDataOrFile{1});
    
    if isExplicitFileArray
        fileArray = inputDataOrFile;
        % has to be determined otherwise...
        dimInfoExtra = MrDimInfo('dimLabels', {'file'}, 'samplingPoints', ...
            1:numel(fileArray));
    else
        fileArray = get_filenames(inputDataOrFile);
        % check whether dimInfo is there
        dimInfoFileIndex = contains(fileArray, '_dimInfo.mat');
        hasDimInfoFile = any(dimInfoFileIndex);
        if hasDimInfoFile
            fileDimInfo = fileArray(dimInfoFileIndex);
            fileArray(dimInfoFileIndex) = [];
        end
        % Determine between-file dimInfo from file name array
        dimInfoExtra = MrDimInfo();
        dimInfoExtra.set_from_filenames(fileArray);
        
        % remove singleton dimensions
        dimInfoExtra.remove_dims();
        
        % now use select to only load subset of files
        [selectDimInfo, selectIndexArray, unusedVarargin] = ...
            dimInfoExtra.select(select);
    end
    
    nFiles = numel(fileArray);
    
    %% Single file can be loaded individually
    if nFiles == 1
        % 2nd output argument is affine geometry, loaded here to not touch
        % the same file multiple times
        read_single_file(this, fileArray{1}, 'dimInfo', dimInfo, loadInputArgs{:});
    else
        %% load and concatenate multiple files
        
        tempDataNd = this.copyobj();
        tempDataNd.read_single_file(fileArray{1});
        tempDataNd.dimInfo.remove_dims();
        tempData = zeros([tempDataNd.dimInfo.nSamples, dimInfoExtra.nSamples]);
        
        %% data first
        for iFile = 1:nFiles
            fprintf('Loading File %d/%d\n', iFile, nFiles);
            fileName = fileArray{iFile};
            tempDataNd.read_single_file(fileName);
            resolutions = tempDataNd.dimInfo.resolutions;
            
            %% todo: generalize!
            [dimLabels, dimValues, pfx, sfx] = get_dim_labels_from_string(fileName);
            
            dimLabelsExtra = dimInfoExtra.dimLabels;
            nExtraDims = numel(dimLabelsExtra);
            indExtraDim = zeros(1, nExtraDims);
            for iExtraDim = 1:nExtraDims
                labelExtraDim = dimLabelsExtra{iExtraDim};
                indExtraDim(iExtraDim) = dimValues(find_string(dimLabels, labelExtraDim));
            end
            
            % write out indices to be filled in final array, e.g. tempData(:,:,sli, dyn)
            % would be {':', ':', sli, dyn}
            index = repmat({':'}, 1, tempDataNd.dimInfo.nDims);
            index = [index, num2cell(indExtraDim)];
            tempData(index{:}) = tempDataNd.data;
        end
        this.data = tempData;
        this.info{end+1,1} = ...
            sprintf('Constructed from %s', pfx);
        tempDataNd.dimInfo.remove_dims();
        %% TODO
        this.name = tempDataNd.name;
        %% combine dimInfos
        dimLabels = [tempDataNd.dimInfo.dimLabels dimInfoExtra.dimLabels];
        dimLabels = regexprep(dimLabels, 'sli', 'z');
        dimLabels = regexprep(dimLabels, 'm', 'x');
        dimLabels = regexprep(dimLabels, 'p', 'y');
        nDims = numel(dimLabels);
        resolutions((end+1):nDims) = 1;
        units = [tempDataNd.dimInfo.units dimInfoExtra.units];
        this.dimInfo = MrDimInfo('dimLabels', dimLabels, 'units', units, 'nSamples', ...
            size(this.data), 'resolutions', resolutions);
        
        % load dimInfo and update
        if hasDimInfoFile
            dimInfoFromFile = load(fileDimInfo{1}, 'dimInfo');
            dimInfoFromFile = dimInfoFromFile.dimInfo;
            % update if same number of samples
            if isequal(this.dimInfo.nSamples, dimInfoFromFile.nSamples)
                update_properties_from(this.dimInfo, dimInfoFromFile);
            else
                warning('DimInfo file exist, but number of samples does not match');
            end
        end
        
        
        %% combine data, sort into right dimInfo-place
        %     this.dimInfo =
        %         this.append(tempDataNd);
    end
    
    
end