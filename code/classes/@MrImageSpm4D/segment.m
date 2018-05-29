function [varargout] = ...
    segment(this, tissueTypes, mapOutputSpace, ...
    deformationFieldDirection, applyBiasCorrection, ...
    fileTPM, warpingRegularization)
% Segments brain images using SPM's unified segmentation approach.
% This warps the brain into a standard space and segment it there using tissue
% probability maps in this standard space. 
%
% Since good warping and good segmentation are interdependent, this is done 
% iteratively until a good tissue segmentation is given by probality maps
% that store how likely a voxel is of a certain tissue type 
% (either in native or standard space).
% Furthermore, a deformation field from native to standard space (or back) 
% has then been found for warping other images of the same native space.
%
%   Y = MrImage()
%   [tissueProbMaps, deformationFields, biasField] = ...
%   Y.segment(tissueTypes, mapOutputSpace, deformationFieldDirection, ...
%       applyBiasCorrection)
%
% This is a method of class MrImage.
% 
% NOTE: If a 4D image is given, only the 1st volume will be segmented
%
% IN
%   tissueTypes         cell(1, nTissues) of strings to specify which 
%                       tissue types shall be written out:
%                       'GM'    grey matter
%                       'WM'    white matter
%                       'CSF'   cerebrospinal fluid
%                       'bone'  skull and surrounding bones
%                       'fat'   fat and muscle tissue
%                       'air'   air surrounding head
%                       
%                       default: {'GM', 'WM', 'CSF'}
%                       
%   mapOutputSpace    'native' (default), 'warped'/'mni'/'standard' or
%                       'both'
%                       defines coordinate system in which images shall be
%                       written out; 
%                       'native' same space as image that was segmented
%                       'warped' standard Montreal Neurological Institute
%                                (MNI) space used by SPM for unified segmentation
%  deformationFieldDirection determines which deformation field shall be
%                       written out,if any
%                       'none' (default) no deformation fields are stored
%                       'forward' subject => mni (standard) space
%                       'backward'/'inverse' mni => subject space
%                       'both'/'all' = 'forward' and 'backward'
%  applyBiasCorrection  true or false (default)
%                       if true, image data will be corrected for estimated
%                       bias field (i.e. B1-inhomogeneity through transmit
%                       or receive coil sensitivities)
%   
% OUT
%   tissueProbMaps      cell(nTissues,1) of 3D MrImages
%                       containing the tissue probability maps in the
%                       respective order as volumes, 
%   deformationFields   (optional) cell(nDeformationFieldDirections,1)
%                       if deformationFieldDirection is 'both', this cell
%                       contains the forward deformation field in the first
%                       entry, and the backward deformation field in the
%                       second cell entry; otherwise, a cell with only one
%                       element is returned
%   biasField           (optional) bias field
%   
% EXAMPLE
%   segment
%
%   See also MrImage spm_preproc
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-07-08
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
% $Id: segment.m 464 2018-05-03 06:24:01Z sklein $

if this.geometry.nVoxels(4) > 1
    warning('This is a 4D Image. Only Volume 1 will be segmented');
end

% save image file for processing as nii in SPM
this.save('fileName', this.get_filename('raw'));

if nargin < 2
    tissueTypes = {'WM', 'GM', 'CSF'};
end

if nargin < 3
    mapOutputSpace = 'native';
end

if nargin < 4
    deformationFieldDirection = 'none';
end

if nargin < 5
    applyBiasCorrection = false;
end

if nargin < 6
    fileTPM = [];
end 

if nargin < 7 
    warpingRegularization = [0 0.001 0.5 0.05 0.2];
end

matlabbatch = this.get_matlabbatch('segment', tissueTypes, ...
    mapOutputSpace, deformationFieldDirection, applyBiasCorrection, ...
    fileTPM, warpingRegularization);

save(fullfile(this.parameters.save.path, 'matlabbatch.mat'), ...
            'matlabbatch');
spm_jobman('run', matlabbatch);

% clean up: move/delete processed spm files, load new data into matrix

varargout = cell(1,nargout);
[varargout{:}] = this.finish_processing_step('segment', ...
    tissueTypes, mapOutputSpace, ...
    deformationFieldDirection, applyBiasCorrection, ...
    fileTPM);