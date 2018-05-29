% Script demo_multi_echo_realign
% Shows realignment for n-dimensional data with different scenarios of 4D
% subsets feeding into estimation, and parameters applied to other subsets,
% e.g.
%   - standard 4D MrImageSpm realignment
%   - multi-echo data, 1st echo realigned, applied to all echoes
%   - complex data, magnitude data realigned, phase data also shifted
%
%  demo_realign
%
%  demo_multi_echo_realign
%
%
%   See also
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2018-05-27
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
% $Id: new_script2.m 354 2013-12-02 22:21:41Z kasperla $
%


clear;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. 4D fMRI, real valued, standard realignment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pathExamples = get_path('examples');
fileTest = fullfile(pathExamples, 'nifti', 'rest', 'fmri_short.nii');

% load data
I4D = MrImage(fileTest);

rI4D = I4D.copyobj.realign();
plot(I4D - rI4D, 't', I4D.dimInfo.t.nSamples);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. 4D fMRI, complex valued, realignment of magnitude and also applied to phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nSamples = [48, 48, 9, 3];
data = randn(nSamples);
dataReal = create_image_with_index_imprint(data);
% to change orientation of imprint in imag part
dataImag = permute(create_image_with_index_imprint(data),[2 1 3 4]);
IComplex = MrImage(dataReal+1i*dataImag, ...
    'dimLabels', {'x', 'y', 'z', 't'}, ...
    'units', {'mm', 'mm', 'mm', 's'}, ...
    'resolutions', [1.5 1.5 3 2], 'nSamples', nSamples);

IComplex.real.plot();
IComplex.imag.plot();
rIComplex = IComplex.copyobj.realign;
plot(IComplex.abs - rIComplex.abs, 't', IComplex.dimInfo.t.nSamples)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. 5D multi-echo fMRI, realignment variants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pathExamples = get_path('examples');
pathMultiEcho = fullfile(pathExamples, 'nifti', 'data_multi_echo');

ME = MrImage(pathMultiEcho);
ME.plot('t', 1);

%% a) Realign via 1st echo

rME = ME.copyobj;
rME = rME.realign('applicationIndexArray', {'echo', 1:3});
plot(rME-ME, 't', ME.dimInfo.t.nSamples);

%% b) Realign via mean of echoes
r2ME = ME.copyobj;
r2ME = r2ME.realign('representationIndexArray', r2ME.mean('echo'), ...
    'applicationIndexArray', {'echo', 1:3});
plot(r2ME-ME, 't', 11);
plot(r2ME-rME, 't', 11);
