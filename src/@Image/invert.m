function res = invert(obj)
% Invert an image (compute its complement).
%
%   INV = invert(IMG);
%
%   Example
%     img = Image.read('cameraman.tif');
%     show(invert(img));
%
%   See also
%     imcomplement
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

newName = createNewName(obj, '%s-inv');

res = Image('Data', imcomplement(obj.Data), 'Parent', obj, 'Name', newName);
