function b = isComplex(this)
%isComplex Checks if an image is scalar (only one channel)
%
%   B = isComplex(IMG)
%   Returns trus if the image is scalar, i.e. has only one channel. Example
%   of scalar images includes grayscale images, binary images, and
%   intensity images.
%
%   Example
%     img = Image.read('cameraman.tif');
%     isComplex(img)
%     ans =
%         1
%
%     img = Image.read('peppers.png');
%     isComplex(img)
%     ans =
%         0
%
%   See also
%     isVector, isGrayscale, isBinary, isIntensity
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = strcmp(this.type, 'complex');