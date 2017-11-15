function b = isBinaryImage(this)
%ISBINARYIMAGE Checks if an image is binary (only black and white)
%
%   B = isBinaryImage(IMG)
%
%   Example
%     img = Image.read('cameraman.tif');
%     isBinaryImage(img)
%     ans =
%         0
%
%     img = Image.read('circles.png');
%     isBinaryImage(img)
%     ans =
%         1
%
%   See also
%     isGrayscaleImage, isScalarImage, isColorImage
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-09-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = strcmp(this.type, 'binary');
