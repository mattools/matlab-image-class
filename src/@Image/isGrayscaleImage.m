function b = isGrayscaleImage(obj)
% Checks if an image is grayscale.
%
%   B = isGrayscaleImage(IMG)
%   Returns true if an image is grayscale. Note that binary images are
%   considered as grayscale. Scalar image that are not grayscale can be
%   intensity or label images.
%
%
%   Example
%     img = Image.read('cameraman.tif');
%     isGrayscaleImage(img)
%     ans =
%         1
%
%     img = Image.read('peppers.png');
%     isGrayscaleImage(img)
%     ans =
%         0
%
%
%   See also
%     isBinaryImage, isIntensityImage, isLabelImage, isColorImage,
%     isScalarImage
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-09-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = strcmp(obj.Type, 'grayscale') || strcmp(obj.Type, 'binary');
