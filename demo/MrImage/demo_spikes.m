% Script demo_spikes
% demonstrates the sensitivty of different quality measures to kpsace spikes 
%
%  demo_spikes
%
%
%   See also
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
% $Id: new_script2.m 354 2013-12-02 22:21:41Z kasperla $
%

clear;
close all;
clc;

doInteractive       = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('C:\Users\uqsboll2\Desktop\test_uniQC\matrixSpikes.mat', 'matrixSpikes');
spikes = MrImage(matrixSpikes);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spikes.name = 'imageSpikes';
% static plot - looks good
spikes.plot('t', 1:spikes.dimInfo.t.nSamples, ...
    'sliceDimension', 't', 'signalPart', 'abs');
plot(spikes.snr, 'colorBar', 'on');
% dynamic plot
% play video - not so good
spikes.plot('useSlider', true, 'signalPart', 'abs');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check difference images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
diffSpikes          = spikes - mean(spikes);
diffSpikes.name     = 'diffSpikes';
% plot again - better!
diffSpikes.plot('t', 1:diffSpikes.dimInfo.t.nSamples, ...
    'sliceDimension', 't', 'signalPart', 'abs');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot suspicious volume
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trouble volume: 12
spikes.plot('t', 11:13, 'displayRange', [0. 0.5]);
diffSpikes.plot('t', 11:13, 'displayRange', [0 0.1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ROI analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if doInteractive
    % draw ROI by clicking the mouse at different prositions to create a
    % region of interest, double-click to finish
    roi = diffSpikes.draw_mask;
    roi.plot;
    diffSpikesAbs = diffSpikes.abs.analyze_rois(roi);
    diffSpikesAbs.rois{1}.plot
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Identify spikes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spikes.plot('t', 29, 'displayRange', [0. 0.5]);
diffSpikes.plot('t', 29, 'displayRange', [0 0.1]);
fftSpikes = abs(spikes.image2k);
fftSpikes.name = 'fft spikes';
diffFftSpikes = fftSpikes - mean(fftSpikes);
diffFftSpikes.name = 'diff fft spikes';
diffFftSpikes.plot('t', 29);
