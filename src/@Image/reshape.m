function res = reshape(obj, dims)
% Reshape an image.
%
%   RES = reshape(IMG, DIMS)
%
%   Example
%     img = Image.read('rice.png');
%     img2 = reshape(img, [512 128]);
%     show(img2)
%
%   See also
%     resize, permute
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-06-09,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - Cepia Software Platform.

newData = reshape(obj.Data, dims);

% create a new Image
name = createNewName(obj, '%s-reshape');
res = Image('Data', newData, 'Parent', obj, 'Name', name);
