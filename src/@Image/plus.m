function res = plus(this, that)
%PLUS Overload the plus operator for image objects
%
%   output = plus(input)
%
%   Example
%   plus
%
%   See also
% 
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract data
[data1 data2 parent name1 name2] = parseInputCouple(this, that, ...
    inputname(1), inputname(2));

% compute new data
newData = bsxfun(@plus, ...
    cast(data1, class(parent.data)), cast(data2, class(parent.data)));

% create result image
newName = strcat(name1, '+', name2);
nd = ndims(this);
res = Image(nd, 'data', newData, 'parent', parent, 'name', newName);
