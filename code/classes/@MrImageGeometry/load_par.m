function this = load_par(this, filename)
% Loads Par (Philips)-Header information referring to geometry into object
%
%   Y = MrImageGeometry()
%   Y.load_par(fileName)
%
% This is a method of class MrImageGeometry.
%
% NOTE: This is based on the header read-in from GyroTools ReadRecV3
%
% IN
%
% OUT
%
% EXAMPLE
%   load_par
%
%   See also MrImageGeometry read_par_header
%
% Author:   Lars Kasper & Laetitia Vionnet
% Created:  2016-01-31
% Copyright (C) 2016 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3. 
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: load_par.m 364 2017-10-25 21:35:40Z lkasper $

header = read_par_header(filename);


%% rotated data matrix depending on slice acquisition orientation
% (transverse, sagittal, coronal)
ori             = header.sliceOrientation;
resolution_mm   = [header.xres, header.yres, header.zres];
% encdir          =

angulation_deg  = header.angulation_deg; % Angulation midslice(ap,fh,rl)[degr]
offcenter_mm    = header.offcenter_mm;  % Off Centre midslice(ap,fh,rl) [mm]
FOV_mm          = header.FOV_mm; % FOV (ap,fh,rl) [mm]

switch ori
    case 1 % transversal, dim1 = ap, dim2 = fh, dim3 = rl (ap fh rl)
        ind = [3 1 2];    % ap,fh,rl to rl,ap,fh
        ind_res = [1 2 3]; % OR [2 1 3];    % x,y,z to rl,ap,fh
        ang_sgn = [1 -1 -1];% ap,fh,rl - checked 26 02 2016
    case 2 % sagittal, dim1 = ap, dim2 = fh, dim3 = lr
        ind = [3 1 2]; 
        ind_res = [3 1 2];  % OR [3 2 1]   
        ang_sgn = [-1 -1 -1];% ap,fh,rl - checked 26 02 2016
    case 3 % coronal, dim1 = lr, dim2 = fh, dim3 = ap
        ind = [3 1 2]; 
        ind_res = [1 3 2]; % OR [2 3 1]; % x,y,z to rl,ap,fh
        ang_sgn = [-1 -1 1];% ap,fh,rl
end

angulation_deg  = angulation_deg.*ang_sgn; % (ap, fh, rl)

%% perform matrix transformation from (ap, fh, rl) to (x,y,z);
% (x,y,z) is (rl,ap,fh)

offcenter_mm    = offcenter_mm(ind);
angulation_deg  = angulation_deg(ind);
resolution_mm   = resolution_mm(ind);
FOV_mm          = FOV_mm(ind_res);

this.update(...
    'resolution_mm', resolution_mm, ...
    'offcenter_mm', offcenter_mm, ...
    'rotation_deg', angulation_deg, ...
    'FOV_mm', FOV_mm, ...
    'TR_s', header.TR_s, ...
    'sliceOrientation', header.sliceOrientation, ...
    'coordinateSystem', 'scanner'); 

%TODO make coord system philips and incorporate axis change!
