function this = reslice(this, targetGeometry)
% Resizes image to image size of other image using spm_reslice
%
%   Y = MrImage()
%   Y.reslice(targetGeometry)
%
%   OR
%   Y.reslice(otherImage);
%
% This is a method of class MrImage.
%
% IN
%   targetGeometry     object of MrImageGeometry or MrImage
%                      Image will be resliced to this geometry
%
%
% OUT
%
% EXAMPLE
%   Y = MrImage();
%   Z = MrImage();
%   targetGeometry = Z.geometry;
%   Y.reslice(targetGeometry)
%
%   See also MrImage MrImageGeometry spm_reslice spm_run_coreg
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-07-18
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
% $Id: reslice.m 463 2018-05-02 10:41:56Z lkasper $

% Save as nifti to use spm functionality
this.save('fileName', this.get_filename('raw'));

if nargin < 2 % reslice to sth that does not need a header, i.e. voxel space = world space
    targetGeometry = MrImageGeometry();
    targetGeometry.nVoxels = this.geometry.nVoxels;
    targetGeometry.resolution_mm = this.geometry.resolution_mm;
    targetGeometry.offcenter_mm = this.geometry.offcenter_mm;
end

% check whether input is actually a geometry
isGeometry = isa(targetGeometry, 'MrImageGeometry');
if ~isGeometry
    if isa(targetGeometry, 'MrImage')
        targetGeometry = targetGeometry.geometry;
    else
        disp('Input has to be of class MrImage or MrImageGeometry.');
    end
end

[diffGeometry, isEqual, isEqualGeom3D] = targetGeometry.diffobj(this.geometry);

if ~isEqualGeom3D
    
    % Dummy 3D image with right geometry is needed for resizing
    emptyImage = targetGeometry.create_empty_image('z', 1);
    emptyImage.parameters.save.path = this.parameters.save.path;
    emptyImage.save();
    fnTargetGeometryImage = emptyImage.get_filename;
    
    matlabbatch = this.get_matlabbatch('reslice', fnTargetGeometryImage);
    save(fullfile(this.parameters.save.path, 'matlabbatch.mat'), ...
        'matlabbatch');
    spm_jobman('run', matlabbatch);
    
    % clean up: move/delete processed spm files, load new data into matrix
    this.finish_processing_step('reslice', fnTargetGeometryImage);
end
end