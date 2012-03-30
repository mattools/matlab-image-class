function b = isGrayscale(this)
%ISGRAYSCALE Checks if an image is grayscale
%
%   Note: deprecated ! use "isGrayscaleImage" instead.
%
%   B = isGrayscale(IMG)
%   Returns true if an image is grayscale. Note that binary images are
%   considered as grayscale. Scalar image that are not grayscale can be
%   intensity or label images.
%
%
%   Example
%     img = Image.read('cameraman.tif');
%     isGrayscale(img)
%     ans =
%         1
%
%     img = Image.read('peppers.png');
%     isGrayscale(img)
%     ans =
%         0
%
%
%   See also
%     isGrayscaleImage
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

warning('Image:deprecated', ...
    'method "isGrayscale" is deprecated, use "isGrayscaleImage" instead');

b = strcmp(this.type, 'grayscale') || strcmp(this.type, 'binary');
