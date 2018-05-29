function fn = get_fig_name(fh, isSaveCompatible)
% Automatically creates reasonable figure name based on Name, suptitle or axis
% title
%
%       fn = get_fig_name(fh)
% IN
%    fh                 figure handle (default gcf)
%    isSaveCompatible   {0} set to 1 to remove blanks, slashes, colons
%                       etc...
% OUT
%   fn  figure name
%
% EXAMPLE
%   get_fig_name
%
%   See also
%
% Author: Lars Kasper
% Created: 2013-11-07
% Copyright (C) 2013 Institute for Biomedical Engineering, ETH/Uni Zurich.
% $Id: get_fig_name.m 200 2015-08-31 12:08:54Z lkasper $
if ~nargin
    fh = gcf;
end

if nargin < 2
    isSaveCompatible = false;
end

% compatibility with Matlab 2014b and beyond
if isNewGraphics() && ishandle(fh)
    figure(fh);
    fh = gcf;
    fhNumber = fh.Number;
else
    fhNumber = fh;
end

fn = get(fh, 'Name');
if isempty(fn) % name from suptitle
    fn = get(get(findall(fh, 'Tag', 'suptitle'),'Children'),'String');
end
if isempty(fn) % name from title
    figure(fh);
    fn = get(get(gca, 'Title'), 'String');
end
if isempty(fn) % name from title
    fn = sprintf('fig%03d',fhNumber);
end

if isSaveCompatible
    fn = str2fn(fn);
end