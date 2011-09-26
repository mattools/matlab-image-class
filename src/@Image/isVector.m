function b = isVector(this)
%ISVECTOR Checks if an image is vector (more than one channel)
%
%   B = isVector(IMG)
%   Returns trus if the image is vector. Vector image have several
%   channels, contrary to scalar images that have only one.
%   Note that color and complex images are considered as vector images.
%
%   Example
%     img = Image.read('cameraman.tif');
%     isVector(img)
%     ans =
%         0
%
%     img = Image.read('peppers.png');
%     isVector(img)
%     ans =
%         1
%
%   See also
%     isScalar, isGrayscale, isColor
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = this.dataSize(4) > 1;