% Script demo_split_complex
% splits complex 4D data in 5D magn/phase or real/imag
%
%  demo_split_complex
%
%
%   See also
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2018-05-22
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
% $Id: demo_split_complex.m 514 2018-05-28 01:51:44Z sklein $
%
 
 
clear;
close all;
clc; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create complex noise data with imprints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
nSamples = [48, 48, 9, 3];
data = randn(nSamples);
dataReal = create_image_with_index_imprint(data);
% to change orientation of imprint in imag part
dataImag = permute(create_image_with_index_imprint(data),[2 1 3 4]); 
I = MrImage(dataReal+1i*dataImag, ...
    'dimLabels', {'x', 'y', 'z', 't'}, ...
    'units', {'mm', 'mm', 'mm', 's'}, ...
    'resolutions', [1.5 1.5 3 2], 'nSamples', nSamples);

I.real.plot();
I.imag.plot();


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Split into magn/phase or real/imag
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I_mp = I.split_complex('mp');
I_mp.plot('echo', 1, 'complex_mp', [1 2]);

I_ri = I.split_complex('ri');
I_ri.plot('echo', 1, 'complex_ri', [1 2]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Recombine into magn/phase or real/imag
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I_cpx_mp =  I_mp.combine_complex();
I_cpx_ri =  I_ri.combine_complex();


I_cpx_mp.real.plot();
I_cpx_mp.imag.plot();


I_cpx_ri.real.plot();
I_cpx_ri.imag.plot();


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Try some smoothing...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sI = I.copyobj.smooth(I.dimInfo.resolutions('x'));
sI.real.plot();
sI.imag.plot();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Try realign...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I2 = I.copyobj.realign;