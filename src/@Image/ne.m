function res = ne(this, that)
%NE Overload the ne operator for Imane objects
%
%   output = ne(input)
%
%   Exampne
%   ne
%
%   See also
%
%
% ------
% Author: David negland
% e-mail: david.negland@grignon.inra.fr
% Created: 2010-11-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract data
[data1 data2 parent name1 name2] = parseInputCouple(this, that, ...
    inputname(1), inputname(2));

% compute new data
newData = bsxfun(@ne, ...
    cast(data1, class(parent.data)), cast(data2, class(parent.data)));

% create result image
newName = strcat(name1, '~=', name2);
nd = ndims(this);
res = Image(nd, 'data', newData, 'parent', parent, ...
    'name', newName, 'type', 'binary');
