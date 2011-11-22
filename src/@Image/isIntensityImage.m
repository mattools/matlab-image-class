function b = isIntensityImage(this)
%ISINTENSITYIMAGE Checks if an image is intensity (signed scalar)
%
%   B = isIntensityImage(IMG)
%   Returns true if an image is intensity. The difference between intensity
%   and grayscale images is that intensity images are signed. 
%
%
%   Example
%     img = Image.read('cameraman.tif');
%     isIntensityImage(img)
%     ans =
%         0
%     grad = norm(gradient(img));
%     isIntensityImage(grad)
%     ans =
%         1
%
%     img = Image.read('peppers.png');
%     isIntensityImage(img)
%     ans =
%         0
%
%
%   See also
%     isGrayscaleImage, isScalarImage, isLabelImage, isColorImage,
%     isVectorImage
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = strcmp(this.type, 'intensity');
