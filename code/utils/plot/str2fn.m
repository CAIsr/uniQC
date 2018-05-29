function fn = str2fn(str)
% reformats string so that it could be a filename (without space colon etc)
%
%   output = str2save(input)
%
% IN
%   str     string
% OUT
%   fn      file-name compatible string without spaces, dots, slashes etc.
% EXAMPLE
%   str2save
%
%   See also
%
% Author: Lars Kasper
% Created: 2013-11-07
% Copyright (C) 2013 Institute for Biomedical Engineering, ETH/Uni Zurich.
% $Id: str2fn.m 288 2016-04-07 07:16:39Z lkasper $
fn = regexprep(regexprep(regexprep(regexprep(str,'(\\|%|:|\(|\)|/|,|\s|=|;)*', '_')...
    , '_(_)* ','_'), '\.', 'c'), '-', 'm');