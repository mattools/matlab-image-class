function b = isScalarImage(this)
%ISSCALARIMAGE Checks if an image is scalar (only one channel)
%
%   B = isScalarImage(IMG)
%   Returns trus if the image is scalar, i.e. has only one channel. Example
%   of scalar images includes grayscale images, binary images, and
%   intensity images.
%
%   Example
%     img = Image.read('cameraman.tif');
%     isScalarImage(img)
%     ans =
%         1
%
%     img = Image.read('peppers.png');
%     isScalarImage(img)
%     ans =
%         0
%
%   See also
%     isVectorImage, isGrayscaleImage, isBinaryImage, isIntensityImage
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-09-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = this.dataSize(4) == 1;