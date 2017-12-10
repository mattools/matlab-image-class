function b = isColorImage(this)
%ISCOLORIMAGE Checks if an image is color
%
%   B = isColorImage(IMG)
%
%   Example
%     img = Image.read('cameraman.tif');
%     isColorImage(img)
%     ans =
%         0
%
%     img = Image.read('peppers.png');
%     isColorImage(img)
%     ans =
%         1
%
%
%   See also
%     isGrayscaleImage, isVectorImage, isBinaryImage
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-09-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = strcmp(this.type, 'color');
