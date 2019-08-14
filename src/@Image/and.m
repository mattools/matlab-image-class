function res = and(this, that)
% Overload the AND operator for Image objects.
%
%   RES = and(IMG1, IMG2)
%
%   Example
%   and
%
%   See also
%     or, xor

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract data
[data1, data2, parent, name1, name2] = parseInputCouple(this, that, ...
    inputname(1), inputname(2));

% compute new data
newData = builtin('and', data1, data2);

% create result image
newName = strcat(name1, '&', name2);
res = Image('data', newData, 'parent', parent, 'name', newName);
