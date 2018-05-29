function outputImage = image2k(this, applicationDimensions)
% Computes k-space representation (scaled/circshifted FFT) of image
%
% default: image per slice by applying transformImage2Kspace, but 3D or
% time series (4th dim) possible as well)
%
%   Y = MrImage();
%   image2kY = Y.image2k(applicationDimensions)
%   image2kY = image2k(Y, applicationDimensions);
%
%
% This is a method of class MrImage.
%
% NOTE: transformImage2Kspace is a function of the Recon-Code of the IBT
%       Zurich, not part of this toolbox; if transformImage2Kspace is not available, fft2 is
%       performed
%
% IN
%
%   applicationDimensions    1, 2, 3, 4 or '2D', '3D'
%                           default: '2D'
%
%                           1...4
%                           data is permuted to have applicationDimensions
%                           as the 4th, then 3D-transformImage2kSpace is
%                           performed
%                           
%                           '2D'
%                           slice-wise operation, looped over
%                           slices/volumes
%
%                           '3D'
%                           operation performed on each 3D volume
%                           separately, looped over volumes
%
% OUT
%   outputImage             image2k part image
%
% EXAMPLE
%   image2kY = image2k(Y)
%
%   See also MrImage MrImage.perform_unary_operation
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-11-29
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
% $Id: new_method2.m 354 2013-12-02 22:21:41Z kasperla $

if nargin < 2
    applicationDimensions = '2D';
end

% string 't' or single numbers are one dimensional applications, others are
% multidimensional
isOneDimensional = ...
    (ischar(applicationDimensions) && strcmpi(applicationDimensions, 't')) || ...
    (isnumeric(applicationDimensions) && numel(applicationDimensions) == 1);

if isOneDimensional
    % since fftn operates on whole array, explicitly state 1D FFT for single
    % application dimension specified
    functionHandle = @(y) ifftshift(ifft(fftshift(y)))*sqrt(numel(y));
else
    if exist('transformImageToKspace')
        functionHandle = @transformImageToKspace;
    else
        functionHandle = @(y) ifftshift(ifftn(fftshift(y)))*sqrt(numel(y));
    end
end

outputImage = this.perform_unary_operation(functionHandle, ...
    applicationDimensions);