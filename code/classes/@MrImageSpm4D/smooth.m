function this = smooth(this, fwhmMillimeter)
% Smoothes image (or image time series) spatially with Gaussian kernel
%
%   Y = MrImageSpm4D()
%   Y = Y.smooth(fwhmMillimeter)
%
% This is a method of class MrImageSpm4D.
%
% IN
%   fwhmMillimeter  Full width at half maximum of Gaussian kernel (in mm)
% OUT
%
% EXAMPLE
%   smooth
%
%   See also MrImageSpm4D
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-07-02
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
% $Id: smooth.m 509 2018-05-25 23:09:41Z lkasper $

if length(fwhmMillimeter) == 1
    fwhmMillimeter = fwhmMillimeter*[ 1 1 1];
end


% save image file for processing as nii in SPM
this.save('fileName', this.get_filename('raw'));

matlabbatch = this.get_matlabbatch('smooth', fwhmMillimeter);
save(fullfile(this.parameters.save.path, 'matlabbatch.mat'), ...
            'matlabbatch');
spm_jobman('run', matlabbatch);

% clean up: move/delete processed spm files, load new data into matrix

this.finish_processing_step('smooth');