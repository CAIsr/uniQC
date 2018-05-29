function imageCombined = combine(this, varargin)
% Combines multiple MrImages into a single one along specified
% dimensions. Basically MrDataNd.combine with additional
% affineGeometry-check
%
%   Y = MrImage()
%   imageCombined = Y.combine(imageArray, combineDims)
%
% This is a method of class MrImage.
%
% IN
%
% OUT
%
% EXAMPLE
%   combine
%
%   See also MrImage MrDataNd.combine MrDimInfo.combine
%
% Author:   Lars Kasper
% Created:  2018-05-17
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
% $Id: combine.m 489 2018-05-22 17:39:19Z lkasper $
imageCombined = combine@MrDataNd(this, varargin{:});

%% Check whether affine geometries of all individual objects in match,
% otherwise issue warning
imageArray = varargin{1};
nSplits = numel(imageArray);
for iSplit = 1:nSplits
    % recursive isequal of MrCopyData
    isAffineGeomEqual = isequal(imageCombined.affineGeometry, ...
        imageArray{iSplit}.affineGeometry);
    if ~isAffineGeomEqual
        warning('Affine Geometry of combined image differs from array entry %d', ...
            iSplit);
    end
end

%% Recast (e.g. MrImageSpm4D) as MrImage, if more than 4 non-singleton
% dimensions to avoid inconsistencies of high-dim MrImageSpm4D
if isa(imageCombined, 'MrImageSpm4D') && numel(imageCombined.dimInfo.get_non_singleton_dimensions()) > 4
    imageCombined = imageCombined.recast_as_MrImage();
end