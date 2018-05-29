function [diffObject, isObjectEqual] = diffobj(obj, input_obj, ...
    tolerance)
% Sets all values of obj to [] which are the same in input_obj; i.e. keeps only the distinct differences in obj
%
%   Y = MrCopyData()
%   [diffObject, isObjectEqual] = diffobj(obj, input_obj, ...
%    tolerance)
%
% This is a method of class MrCopyData.
%
% IN
% input_obj     the input MrCopyData from which common elements are subtracted
% tolerance     allowed difference seen still as equal
%               (default: eps(single)
%
% OUT
% diffObject    obj "minus" input_obj
% isObjectEqual true, if obj and input_obj were the same
%
% NOTE: empty values in obj, but not in input_obj remain empty,
% so are not "visible" as different. That's why
% obj.diffobj(input_obj) delivers different results from
% input_obj.diffobj(obj)
%
% EXAMPLE
%   diffobj
%
%   See also MrCopyData
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2016-04-19
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
% $Id: diffobj.m 494 2018-05-23 22:03:03Z lkasper $

if nargin < 3
    tolerance = eps('single'); % machine precision for the used data format
end
isObjectEqual = true;
diffObject = obj.copyobj;
[sel, mobj] = get_properties_to_update(diffObject);

for k = sel(:)'
    pname = mobj.Properties{k}.Name;
    if isa(diffObject.(pname), 'MrCopyData') %recursive comparison
        [diffObject.(pname), isSubobjectEqual] = diffObject.(pname).diffobj ...
            (input_obj.(pname), tolerance);
        isObjectEqual = isObjectEqual & isSubobjectEqual;
    else
        % cell of MrCopyData also treated
        if iscell(diffObject.(pname)) && iscell(input_obj.(pname)) ...
                && ~isempty(diffObject.(pname)) ...
                && isa(diffObject.(pname){1}, 'MrCopyData')
            for c = 1:min(length(diffObject.(pname)),length(input_obj.(pname)))
                [diffObject.(pname){c}, isSubobjectEqual] = diffObject.(pname){c}.diffobj ...
                    (input_obj.(pname){c}, tolerance);
                isObjectEqual = isObjectEqual & isSubobjectEqual;
            end
        else % non-MrCopyData values in current property of obj
            if ~isempty(input_obj.(pname)) && ~isempty(diffObject.(pname))
                p = diffObject.(pname);
                ip = input_obj.(pname);
                
                if ~isnumeric(p) % compare cells, strings via isequal (no tolerance)
                    isPropertyEqual = isequal(p,ip);
                else % check vector/matrix (size) and equality with numerical tolerance?
                    isPropertyEqual = prod(double(size(p)==size(ip)));
                    if isPropertyEqual
                        isPropertyEqual = ~any(abs(p-ip)>tolerance);
                    end
                end
                if isPropertyEqual
                    diffObject.(pname) = [];
                else
                    isObjectEqual = false;
                end
            end
            
        end
    end
end
end
