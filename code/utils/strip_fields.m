function strip_fields(opts)
%strip fields of a structure into workspace variables of calling function
%
%   output = strip_fields(input)
%
% IN
%   opts    structure variable
%
% OUT
%
% SIDE EFFECTS
%   creates variables with field names in workspace of calling function
%
% EXAMPLE
%   strip_fields
%
%   See also propval
%
% Author: Lars Kasper
% Created: 2013-11-13
% Copyright (C) 2013 Institute for Biomedical Engineering, ETH/Uni Zurich.
% $Id: strip_fields.m 12 2014-07-03 16:24:30Z lkasper $
optsArray = fields(opts);
nOpts = length(optsArray);
for iOpt = 1:nOpts
    assignin('caller', optsArray{iOpt}, opts.(optsArray{iOpt}));
end