function s = physicalSize(obj)
% Return the physical size of an image, in user unit.
%
%  SIZ = physicalSize(IMG);
%
%   Example
%     img = Image2D.read('cameraman.tif');
%     physicalSize(img)
%     ans =
%        256 256
%
%   See also
%     ndims, size, physicalExtent, isCalibrated, clearCalibration
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nd = ndims(obj);

% multiply size of data array by element spacing
s = obj.DataSize(1:nd) .* obj.Spacing;
