function axis = parseAxisIndex(axis)
%PARSEAXISINDEX Parse argument and return axis number between 1 and 3
%
%   AXIS = parseAxisIndex(AXIS)
%   If AXIS is a number, checks it is comprised between 1 and 3, and return
%   it. 
%   If AXIS is a string, try to parse 'x', 'y', or 'z', and return the
%   corresponding index.
%   
%
%   Example
%   ind = parseAxisIndex(x)
%   ind = 
%         1
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isnumeric(axis)
    % check index bounds
    if axis<1 || axis>3
        error('Axis index should be comprised between 1 and 3');
    end
    
elseif ischar(axis)
    % Try to parse the axis string
    if strcmpi(axis, 'x')
        axis = 1;
    elseif strcmpi(axis, 'y')
        axis = 2;
    elseif strcmpi(axis, 'z');
        axis = 3;
    else
        error('Unknown direction string. Use ''x'', ''y'' or ''z''');
    end
    
else
    % Otherwise throw an error
    error('Unknown type for axis');
end
