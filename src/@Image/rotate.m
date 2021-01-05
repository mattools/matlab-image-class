function res = rotate(obj, angle, varargin)
% Rotate the current image by the specified angle in degrees.
%
%   IMG2 = rotate(IMG, ANGLE)
%
%   Example
%     % Apply a rotation by 30 degrees to the cameraman image
%     img = Image.read('cameraman.tif');
%     imgRot = rotate(img, 30);
%     show(imgRot)
%
%   See also
%     rotate90
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-12-07,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.

nd = length(obj.Data);
data = permute(obj.Data, [2 1 3:nd]);
data2 = permute(imrotate(data, -angle, varargin{:}), [2 1 3:nd]);

name = createNewName(obj, '%s-rot');
res = Image('Data', data2, 'Parent', obj, 'Name', name);
