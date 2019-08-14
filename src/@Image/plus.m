function res = plus(obj, value)
% Overload the plus operator for image objects.
%
%   RES = plus(IMG, VAL)
%   RES = IMG + VAL
%
%   Example
%   plus
%
%   See also
%     minus, mtimes, mrdivide

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract data
[data1, data2, parent, name1, name2] = parseInputCouple(obj, value, ...
    inputname(1), inputname(2));

% compute new data
newData = bsxfun(@plus, ...
    cast(data1, class(parent.Data)), cast(data2, class(parent.Data)));

% create result image
newName = strcat(name1, '+', name2);
res = Image('data', newData, 'parent', parent, 'name', newName);
