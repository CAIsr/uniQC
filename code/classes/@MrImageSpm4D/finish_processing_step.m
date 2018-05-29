function varargout = finish_processing_step(this, module, varargin)
% finishes current processing step by deleting SPM-related temporary data
% on disk and writing back processed data from disk into data matrix
% results of processing step
%
%   Y = MrImage()
%   Y.finish_processing_step(module, varargin)
%
% This is a method of class MrImage.
%
% IN
%
% OUT
%
% EXAMPLE
%   Y.finish_processing_step('smooth', fileOutputSpm);
%
%   See also MrImage
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-07-03
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
% $Id: finish_processing_step.m 514 2018-05-28 01:51:44Z sklein $

itemsSave = this.parameters.save.keepCreatedFiles;

switch itemsSave
    case 0
        itemsSave = 'none';
    case 1
        itemsSave = 'all';
end

doSave = ~strcmpi(itemsSave, 'none');
doSaveRaw = ismember(itemsSave, {'all'});
doSaveNifti = ismember(itemsSave, {'nii', 'all', 'processed'});
doSaveObject = ismember(itemsSave, {'object', 'all', 'processed'});


pathSave        = this.parameters.save.path;
fileRaw         = this.get_filename('raw');
pathRaw         = fileparts(fileRaw);
fileProcessed   = this.get_filename;
nameImage       = this.name;

% for file prefixes
isSuffix = false;
isMixedCase = true;
doKeepCreatedFiles = (this.parameters.save.keepCreatedFiles == 1) & ...
        ~strcmpi(this.parameters.save.keepCreatedFiles, 'none');
hasMatlabbatch = ismember(module, this.get_all_matlabbatch_methods());
varargout = {};

% nifti leftovers exist and resulting files have to be renamed
if hasMatlabbatch
    fileMatlabbatch = fullfile(this.parameters.save.path, ...
        'matlabbatch.mat');
    filesCreated = {
        fileRaw
        fileProcessed
        fileMatlabbatch
        };
    switch module
        case 'apply_transformation_field'
            prefixOutput = 'w';
            fileOutputSpm = prefix_files(fileRaw, prefixOutput);
            
        case 'coregister_to'
            % has matlabbatch, but does not create unnecessary files...,
            % since matlabbatch not executed...
            prefixOutput = '';
            fileStationaryImage = varargin{1};
            delete_with_hdr(fileStationaryImage);
            fileOutputSpm = varargin{2}; % SPM output of reslice
            filesCreated = [
                filesCreated
                {fileStationaryImage}
                ];
            
        case 'apply_realign'
            
            prefixOutput = 'r';
            fileOutputSpm = prefix_files(fileRaw, prefixOutput);
            filesCreated = {
                fileRaw
                fileProcessed
                };
            
        case 'realign'
            
            prefixOutput = 'r';
            fileOutputSpm = prefix_files(fileRaw, prefixOutput);
      
            fileRealignmentParameters = regexprep(...
                prefix_files(fileRaw, 'rp_'), '\.nii', '\.txt');
            fileRealignMean = prefix_files(fileRaw, 'mean');
            filesCreated = [
                filesCreated
                {fileRealignmentParameters; fileRealignMean}
                ];
            
            varargout{1} = load(fileRealignmentParameters, '-ascii');
            
        case 'reslice'
      
            prefixOutput = 'r';
            fileOutputSpm = prefix_files(fileRaw, prefixOutput);
            
            fnTargetGeometry = varargin{1};
            
            % dummy image of target geometry always deleted
            delete_with_hdr(fnTargetGeometry);
            
        case 'segment'
            
            % the bias-corrected anatomical is the output
            prefixOutput = 'm';
            fileOutputSpm = prefix_files(fileRaw, prefixOutput);
            
            tissueTypes = varargin{1};
            imageOutputSpace = varargin{2};
            deformationFieldDirection = varargin{3};
            applyBiasCorrection = varargin{4};
            
            % get current and new tissue probability map file names
            allTissueTypes = {'GM', 'WM', 'CSF', 'bone', 'fat', 'air'};
            indTissueTypes = find(ismember(lower(allTissueTypes), ...
                lower(tissueTypes)));
            nTissues = numel(indTissueTypes);
            
            filesTpm = cell(nTissues,1);
            filesTpmProcessed = cell(nTissues,1);
            
            for iTissue = 1:nTissues
                indTissue = indTissueTypes(iTissue);
                filesTpm{iTissue} = prefix_files(fileRaw, ...
                    sprintf('c%d%', indTissue));
                filesTpmProcessed{iTissue} = prefix_files( ...
                    fullfile(this.parameters.save.path, sprintf('%s.nii', ...
                    lower(allTissueTypes{indTissue}))), ...
                    'tissueProbabilityMap', isSuffix, isMixedCase);
            end
            
            if ismember(imageOutputSpace, {'mni', 'standard', 'template', 'warped'})
                filesTpm = prefix_files(filesTpm, 'w');
                filesTpmProcessed = prefix_files(filesTpmProcessed, ...
                    'warped', isSuffix, isMixedCase);
            end
            
            
            % determine modulated/unmodulated filename to be loaded to data
            if ~applyBiasCorrection
                % if no application of bias field, create fake output by
                % copying raw.nii to mraw.nii
                copy_with_hdr(fileRaw, fileOutputSpm);
            end
            
            
            % deformation field file names, if saved
            filesDeformationField = {};
            filesDeformationFieldProcessed = {};
            
            hasForwardField = ismember(deformationFieldDirection, {'forward', 'both', 'all'});
            hasBackwardField = ismember(deformationFieldDirection, {'backward', 'both', 'all'});
            if hasForwardField
                filesDeformationField{end+1,1} = prefix_files(fileRaw, 'y_');
                filesDeformationFieldProcessed{end+1,1} = ...
                    fullfile(pathSave, 'forwardDeformationField.nii');
            end
            if hasBackwardField
                filesDeformationField{end+1, 1} = prefix_files(fileRaw, 'iy_');
                filesDeformationFieldProcessed{end+1, 1} = ...
                    fullfile(pathSave, 'backwardDeformationField.nii');
            end
            
            % bias field names
            fileBiasField = cellstr(prefix_files(fileRaw, ...
                'BiasField_'));
            fileBiasFieldProcessed = cellstr(fullfile(pathSave, ...
                'biasField.nii'));
            
            % move all image files to their final names
            filesMoveSource = [
                filesTpm
                filesDeformationField
                fileBiasField
                ];
            filesMoveTarget = [
                filesTpmProcessed
                filesDeformationFieldProcessed
                fileBiasFieldProcessed
                ];
            move_with_hdr(filesMoveSource, filesMoveTarget);
                       
            % now load all output variables
            
            % load tissue probability maps
            doLoadTissueProbabilityMaps = nargin >= 1;
            if doLoadTissueProbabilityMaps
                nTissues = numel(filesTpmProcessed);
                for iTissue = 1:nTissues
                    varargout{1}{iTissue,1} = MrImageSpm4D(filesTpmProcessed{iTissue}, ...
                        'updateProperties', 'all');
                end
            end
            
            % load deformation fields, if wanted
            doLoadDeformationFields = nargout >= 2;
            if doLoadDeformationFields
                varargout{2} = {};
                if hasForwardField
                    varargout{2}{1,1} = MrImage(...
                        filesDeformationFieldProcessed{1}, ...
                        'updateProperties', 'all');
                end
                
                % load bias fields, if wanted
                if hasBackwardField
                    varargout{2}{end+1,1} = MrImage(...
                        filesDeformationFieldProcessed{end}, ...
                        'updateProperties', 'all');
                end
                
            end
            
            
            doLoadBiasField = nargout >= 3;
            if doLoadBiasField
                varargout{3} = MrImage(fileBiasFieldProcessed, ...
                    'updateProperties', 'all');
            end
            
            
            % other file with normalization information for old
            % segmentation
            fileSeg8 = regexprep(fileRaw, '\.nii$', '_seg8\.mat');
            
            % files to be deleted, if specified
            filesCreated = [
                filesCreated
                filesMoveTarget
                fileSeg8
                ];
            
        case 'smooth'
            prefixOutput = 's';
            fileOutputSpm = prefix_files(fileRaw, prefixOutput);
    end
    
    % copy dimInfo to SPM-output file, if it exists
    % coregister has already written new file inlc. dimInfo
    if ~strcmp(module, 'coregister_to')
        fileDimInfoRaw = this.get_filename('dimInfoRaw');
        if exist(fileDimInfoRaw, 'file')
            copyfile(fileDimInfoRaw, prefix_files(fileDimInfoRaw, prefixOutput))
        end
    end
    
    move_with_hdr(fileOutputSpm, fileProcessed);
    
    % load back data into matrix
    this.load(fileProcessed);
    
    % remove NaNs
    this.data(isnan(this.data)) = 0;
    
    % delete all unwanted files
    if ~doSaveRaw
        delete_with_hdr(filesCreated);
        
        % delete raw sub-folder of current processing step
        if exist(pathRaw, 'dir')
            delete(fullfile(pathRaw, '*'));
            rmdir(pathRaw);
        end

        [stat, mess, id] = rmdir(this.parameters.save.path);  
    end
else % no matlabbatch created
    
    % NOTE: this saving is important, e.g. for compute_masks to allow for
    % multiple processing steps within a bigger step to be saved
    if doSave
        this.save();
    end
end

% to preserve name after reloading, because not in nifti-file
this.name = nameImage;

end