function affineGeom = make_affineGeometry_reference(~, varargin)
% create a affineGeometry reference object for unit testing
%
%   Y = MrUnitTest()
%   Y.make_affineGeometry_reference(do_save, fileName)
%
% This is a method of class MrUnitTest.
%
% IN
%
% OUT
%
% EXAMPLE
%   make_affineGeometry_reference
%
%   See also MrUnitTest
%
% Author:   Saskia Bollmann
% Created:  2017-11-30
% Copyright (C) 2017 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3.
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: new_method2.m 354 2013-12-02 22:21:41Z kasperla $

if nargin > 1
    do_save = varargin{1};
else
    do_save = 0;
end

if nargin > 2
    fileName = varargin{2};
    makeFromFile = 1;
else
    makeFromFile = 0;
end

if makeFromFile
    affineGeom = MrAffineGeometry(fileName);
    [~,name] = fileparts(fileName);
    % get classes path
    classesPath = get_path('classes');
    % make full filename using date
    filename = fullfile(classesPath, '@MrUnitTest' , ...
        ['affineGeom-' name datestr(now, 'yyyymmdd_HHMMSS') '.mat']);
else
    affineGeom = MrAffineGeometry(...
        'offcenter_mm', [25, 30, 11], 'rotation_deg', [3 -6 10], ...
        'shear_mm', [0.2 3 1], 'resolution_mm', [1.3 1.3 1.25], ...
        'sliceOrientation', 3, 'displayOffset', 'scanner');
    
    % get classes path
    classesPath = get_path('classes');
    % make full filename using date
    filename = fullfile(classesPath, '@MrUnitTest' , ['affineGeom-' datestr(now, 'yyyymmdd_HHMMSS') '.mat']);
end

if do_save
    if exist(filename, 'file')
        prompt = 'Overwrite current MrAffineGeometry constructor reference object? Y/N [N]:';
        answer = input(prompt, 's');
        if strcmpi(answer, 'N')
            do_save = 0;
        end
    end
end
if do_save
    save(filename, 'affineGeom');
end