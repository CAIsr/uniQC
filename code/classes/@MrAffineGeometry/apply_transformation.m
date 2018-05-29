function this = apply_transformation(this, otherGeometry)
% Performs affine transformation on Geometry by multiplying of 4x4 affine matrix
%
%   Y = MrAffineGeometry()
%   Y.apply_transformation(otherGeometry)
%
% This is a method of class MrAffineGeometry.
%
% IN
%   otherGeometry   MrAffineGeometry holding the affine transformation to be
%                   applied
%                   OR
%                   4x4 affineTransformationMatrix
% OUT
%
% EXAMPLE
%   apply_transformation
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
% $Id: apply_transformation.m 337 2017-07-05 12:40:02Z lkasper $
% in spm_coreg: MM
rawAffineMatrix = this.affineMatrix;

% in spm_coreg: M
if ~isa(otherGeometry, 'MrAffineGeometry')
    % disp('Input parameter not an MrAffineGeometry, assuming affine Matrix');
    otherGeometry = MrAffineGeometry(otherGeometry);
end
affineCoregistrationMatrix = otherGeometry.affineMatrix;

% Transformation is concatenation
processedAffineMatrix = affineCoregistrationMatrix * ...
    rawAffineMatrix;
this.update_from_affine_matrix(processedAffineMatrix);