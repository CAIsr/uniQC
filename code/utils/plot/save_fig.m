function [fnOut, args] = save_fig(varargin)
%save figure with current name as filename (with some removal of bad
%characters for saving
%
%  fnOut = save_fig(fh, type, pathSave, fn, res)
%
% IN
%   varargin:   property name / value pairs for extra options
%
%   fh          figure handle (default gcf) OR vector of figure handles
%   imageType   fig save file type (default 'png');
%   pathSave    path to save to (default pwd)
%
%   fn          file name (default: nice name created from figure name/title)
%   res         resolution
%   doPrefixFigNumber
%               prefixes figure number to file name of figure
%               true if no file name was given
% OUT
%   fnOut       full name (incl path) of output file)
%   args        possible save_fig arguments returned as a structure
%
% EXAMPLE
%   save_fig
%
%   See also get_fig_name str2fn
%
% Author: Lars Kasper
% Created: 2013-11-07
% Copyright (C) 2013 Institute for Biomedical Engineering, ETH/Uni Zurich.
% $Id: save_fig.m 288 2016-04-07 07:16:39Z lkasper $

defaults.fh = gcf;
defaults.imageType = 'png';
defaults.res = 150;
defaults.doCreateName = true;
defaults.pathSave = pwd;
defaults.doPrefixFigNumber = true;
defaults.fn = [];



args = propval(varargin,defaults);
strip_fields(args);

if ~(isempty(fn)) && (numel(fh) == 1)
    doCreateName = false;
    doPrefixFigNumber = false;
end

% Get handles of all figures

if isequal(fh, 'all')
        fhArray = get(0, 'Children');
else
    fhArray = fh;
end


for iFh = 1:numel(fhArray)
    fh = fhArray(iFh);
    if doCreateName
        fn = get_fig_name(fh,1);
    end
    
      % compatibility with Matlab 2014b
    if isNewGraphics() && ishandle(fh)
        figure(fh);
        fh = gcf;
        fhNumber = fh.Number;
    else
        fhNumber = fh;
    end
    
    if doPrefixFigNumber
        fn = sprintf('Fig_%03d_%s', fhNumber, fn);
    end
    
    if iscell(fn), fn = fn{1}; end; % for multiline strings in title, take 1st line only
    fnOut = fullfile(pathSave, [fn, '.', imageType]);
    if ~exist(pathSave, 'dir'), mkdir(pathSave); end;
    set(fh, 'PaperPositionMode', 'auto');
    disp(sprintf('saving figure %d to %s\n', fhNumber, fnOut));
    switch imageType
        case 'fig'
            saveas(fh, fnOut);
        otherwise
            switch imageType
                case 'eps'
                    dFormat = '-depsc2'; renderer = '-painter';
                case 'tif'
                    dFormat = '-dtiff'; renderer = '-OpenGL';
                case 'jpg'
                    dFormat = '-djpeg'; renderer = '-OpenGL';
                otherwise
                    dFormat = sprintf('-d%s',imageType);
            end
            print(fh, sprintf('-r%d',res), dFormat, fnOut);
    end
end