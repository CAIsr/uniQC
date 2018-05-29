function this = apply_realign(this, rp)
% applies realignment parameters from other estimation to this 4D Image
%
%   Y = MrImageSpm4D()
%   Y.apply_realign(inputs)
%
% This is a method of class MrImageSpm4D.
%
% IN
%   rp  [nVolumes,6] realignment parameters, as output by SPM 
%                    (e.g., in rp_*.txt)
%                    in mm and rad: [dx,dy,dz,pitch,roll,yaw]
%                                           (i.e., phi_x,phi_y,phi_z)
% OUT
%
% EXAMPLE
%   apply_realign
%
%   See also MrImageSpm4D spm_run_coreg spm_matrix
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2018-05-25
% Copyright (C) 2018 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the TAPAS UniQC Toolbox, which is released
% under the terms of the GNU General Public License (GPL), version 3. 
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: apply_realign.m 504 2018-05-25 11:28:32Z lkasper $

%% save image file for processing as nii in SPM
this.save('fileName', this.get_filename('raw'));

[pathRaw, fileRaw, ext] = fileparts(this.get_filename('raw'));
fileRaw = [fileRaw ext];
PO = cellstr(spm_select('ExtFPList', pathRaw, ['^' fileRaw], Inf));


%% loop over volumes, Adapting image headers
% applying realignment as relative trafo to existing
% voxel/world mapping, only header (.mat) changed
% code analogous to spm_run_coreg, around line 30 (eoptions)

% 12 parameters of affine mapping, see spm_matrix for their order
x = zeros(1,12);
x(7:9) = 1;

for j = 1:numel(PO)
    x(1:6)  = rp(j,:);
    M  = spm_matrix(x);
    MM = spm_get_space(PO{j});
    spm_get_space(PO{j}, M\MM);
end

quality = 0.9; % can be hardcoded, only dummy!
matlabbatch = this.get_matlabbatch('realign', quality);
job = matlabbatch{1}.spm.spatial.realign.estwrite;


%% Reslicing has to happen here
% has to be before finish, since .mat 4D information not saved by our ...
% objects on this.load('*.nii')

% from spm_run_realign, around line 36, "if isfield(job,'roptions')" etc.
P            = char(PO);
flags.mask   = job.roptions.mask;
flags.interp = job.roptions.interp;
flags.which  = [2 0]; % don't write out mean, but all images
flags.wrap   = job.roptions.wrap;
flags.prefix = job.roptions.prefix;

spm_reslice(P, flags); 
this.finish_processing_step('apply_realign');
