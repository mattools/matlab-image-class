function res = le(obj, that)
% Overload the le operator for Image objects.
%
%   output = le(input)
%
%   Example
%   le
%
%   See also
%     lt, ge, eq, ne
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract data
[data1, data2, parent, name1, name2] = parseInputCouple(obj, that, ...
    inputname(1), inputname(2));

% compute new data
newData = bsxfun(@le, ...
    cast(data1, class(parent.Data)), cast(data2, class(parent.Data)));

% create result image
newName = strcat(name1, '<=', name2);
res = Image('data', newData, 'parent', parent, ...
    'name', newName, 'type', 'binary');
