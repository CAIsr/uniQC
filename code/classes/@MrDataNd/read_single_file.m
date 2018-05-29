function [this, affineGeometry] = read_single_file(this, fileName, varargin)
%loads MrImage from different file types, allowing property-name/value
%pairs to be set for geometry parameters
%
%   Y = MrImage();
%   Y.load(fileName,'PropertyName', PropertyValue, ...);
%
% This is a method of class MrImage.
%
% IN
%   fileName    string
%
%              - supported file-types:
%              .nii         nifti, header info used
%              .img/.hdr    analyze, header info used
%              .cpx         Philips native complex (and coilwise) image
%                           data format
%              .par/.rec    Philips native image file format
%              .mat         matlab file, assumes data matrix in variable 'data'
%                           and parameters in 'parameters' (optional)
%               <data>      workspace variable can be given as input directly
%
%   'PropertyName'/value - pairs possible:
%               'updateProperties'      (cell of) strings containing the
%                                       properties of the object to be updated with the new
%                                       (file)name and its data
%                                       'name'  name is set to file name
%                                              (default)
%                                       'save'  parameters.save.path and
%                                               parameters.save.fileUnprocessed
%                                               are updated to match the input
%                                               file name
%                                       'none'  only data and geometry
%                                               updated by loading
%                                       'all'   equivalent to
%                                       {'name','save'}
%
%
%
% OUT
%
%   See also MrDataNd.load
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-09-24
% Copyright (C) 2014 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public Licence (GPL), version 3.
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: read_single_file.m 506 2018-05-25 12:37:35Z lkasper $

if nargin < 2 || isempty(fileName)
    fileName = this.get_filename;
end


defaults.selectedVolumes = Inf;
defaults.selectedCoils = 1; % Inf for all, 0 for SoS-combination
defaults.signalPart = 'abs';
defaults.updateProperties = 'name';
defaults.dimInfo = [];

% input arguments without defaults are assumed to be for
% MrImageGeometry and will be forwarded
[args, argsGeomDimInfo] = propval(varargin, defaults);
strip_fields(args);

doUpdateName = any(ismember({'name', 'all', 'both'}, cellstr(updateProperties)));
doUpdateSave = any(ismember({'save', 'all', 'both'}, cellstr(updateProperties)));

hasInputDimInfo = ~isempty(dimInfo);

isMatrix = isnumeric(fileName) || islogical(fileName);

hasSelectedVolumes = ~isempty(selectedVolumes) && ~any(isinf(selectedVolumes));

if isMatrix
    this.data = fileName;
    this.name = 'workspaceDataMatrix';
    this.info{end+1,1} = ...
        sprintf('Constructed from %s', this.name);
    this.dimInfo = MrDimInfo(); % will be updated later with nSamples, and input dimInfo
    
else %load single file, if existing
    
    hasFoundFile = (exist(fileName, 'file')) > 0;
    if ~hasFoundFile
        warning(sprintf('File %s not existing, clearing data \n', fileName));
        this.data = [];
        ext = '';
    else
        [fp,fn,ext] = fileparts(fileName);
        switch ext
            case '.cpx'
                this.read_cpx(fileName, selectedVolumes, selectedCoils, ...
                    signalPart);
                this.dimInfo = MrDimInfo();
                warning('dimInfo resolution/FOV not initialised for cpx');
            case {'.par', '.rec'}
                % forwards only unused elements
                [this, argsGeomDimInfo] = this.read_par_rec(fileName, argsGeomDimInfo);
            case {'.nii', '.img','.hdr'}
                this.read_nifti_analyze(fileName, selectedVolumes);
            case {'.mat'} % assumes mat-file contains one variable with 3D image data
                % TODO replace by struct2obj to iteratively construct
                % from hierarchical structure
                tmp = load(fileName,'obj');
                obj = tmp.obj;
                
                if isa(obj, 'MrDataNd') % class or sub-class
                    this = obj;
                else
                    switch class(obj)
                        case 'ImageData'
                            this.read_recon6_image_data(obj);
                        otherwise
                            error('Unsupported object format to load into MrDataNd: %s', class(obj));
                    end
                end
                clear obj tmp;
            case ''
                if isdir(fileName) % previously saved object, load
                    % TODO: load MrImage from folder
                else
                    error('File with unsupported extension or non-existing');
                end
        end
        
        % define name from loaded file and data selection parameters
        
        hasSelectedCoils = strcmp(ext, '.cpx') && ~isinf(selectedCoils);
        if hasSelectedCoils
            stringCoils  = ['_coil', sprintf('_%02d', selectedCoils)];
        else
            stringCoils = '';
        end
        
        if doUpdateName
            this.name = sprintf('%s_type_%s%s_%s', fn, ...
                regexprep(ext, '\.', ''), stringCoils, signalPart);
        end
        
        % always update info about file loading
        this.info{end+1,1} = ...
            sprintf('Constructed from %s', fileName);
        
        
        if doUpdateSave
            this.parameters.save.path = fp;
            this.parameters.save.fileName = [fn ext];
        end
        
        
    end % exist(fileName)
end % else isMatrix

% Some loading functions load full dataset, filter out unnecessary parts
% here
hasLoadedAllData = isMatrix || ...
    (hasFoundFile && ismember(ext, {'.par', '.rec', '.mat'}));
if hasLoadedAllData && hasSelectedVolumes
    this.data = this.data(:,:,:,selectedVolumes);
end

% Convert data to double for compatibility with all functions
this.data = double(this.data);
nSamples = size(this.data);

% loads header from nifti/analyze/recon6 files, overwrites other geometry
% properties as given in MrImage.load as property/value pairs
loadDimInfoFromHeader = ~isMatrix && ismember(ext, {'.par', '.rec', ...
    '.nii', '.img', '.hdr', '.mat'});

% check whether actually any data was loaded and we need to update the
% geometry
hasData = ~isempty(this.data);


%% this could also go into a specific MrImage.load routine?
if loadDimInfoFromHeader
    this.dimInfo = MrDimInfo(fileName);
    affineGeometry = MrAffineGeometry(fileName);
else
    this.dimInfo = MrDimInfo();
    affineGeometry = MrAffineGeometry();
end

% update dimInfo using input dimInfo
if hasInputDimInfo
    this.dimInfo.update_and_validate_properties_from(dimInfo);
end

% update number of samples with dims of actually loaded samples
% only, if nSamples incorrect at this point, to allow explicit
% samplingPoints etc. from input-dimInfo to prevail, since the following
% update needs non-NaN resolutions, which not all dims might have
if hasData && ~isequal(nSamples, ...
        this.dimInfo.nSamples(this.dimInfo.get_non_singleton_dimensions())) 
    this.dimInfo.set_dims(1:numel(nSamples), 'nSamples', nSamples);
end

%% Update affineGeometry
% belongs into subclass method, but more easily dealt with here
if isa(this, 'MrImage')
    this.affineGeometry = affineGeometry;
end

