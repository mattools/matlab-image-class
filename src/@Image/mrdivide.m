function res = mrdivide(obj, that)
% Overload the mrdivide operator for image objects.
%
%   RES = mrdivide(IMG, VAL)
%   RES = IMG / VAL
%
%   Example
%     img = Image.read('rice.png');
%     img2 = img / 2;
%     show(img2)
%
%   See also
%     mtimes, plus, minus
% 

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract data
[data1, data2, parent, name1, name2] = parseInputCouple(obj, that, ...
    inputname(1), inputname(2));

% compute new data
newData = bsxfun(@rdivide, ...
    cast(data1, class(parent.Data)), cast(data2, class(parent.Data)));

% create result image
newName = strcat(name1, '/', name2);
res = Image('data', newData, 'parent', parent, 'name', newName);
