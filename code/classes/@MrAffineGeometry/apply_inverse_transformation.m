function this = apply_inverse_transformation(this, otherGeometry)
% Applies inverse of given transformation (as an Image geometry) to this
%
%(e.g. given mapping stationary -> transformed image transformation that
% now shall be applied to transformable image to warp into space of
% stationary image )
%
%   Y = MrAffineGeometry()
%   Y.apply_inverse_transformation(otherGeometry)
%
% This is a method of class MrAffineGeometry.
%
% IN
%   otherGeometry   MrAffineGeometry holding the affine transformation to be
%                   applied
%
% OUT
%
% EXAMPLE
%   apply_inverse_transformation
%
%   See also MrAffineGeometry
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-07-28
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
% $Id: apply_inverse_transformation.m 396 2018-01-17 04:48:25Z sklein $

% in spm_coreg: MM
rawAffineMatrix = this.affineMatrix;

% in spm_coreg: M
if ~isa(otherGeometry, 'MrAffineGeometry')
    % Input parameter not an MrAffineGeometry, assuming affine Matrix
    otherGeometry = MrAffineGeometry(otherGeometry);
end
affineCoregistrationMatrix = otherGeometry.affineMatrix;

% compute inverse transformation via \, efficient version of:
% pinv(affineCoregistrationMatrix) * rawAffineMatrix 
processedAffineMatrix = affineCoregistrationMatrix \ ...
    rawAffineMatrix;
this.update_from_affine_matrix(processedAffineMatrix);