function b = isBinary(this)
%ISBINARY Checks if an image is binary (only black and white)
%
%   B = isBinary(IMG)
%
%   Example
%     img = Image.read('cameraman.tif');
%     isBinary(img)
%     ans =
%         0
%
%     img = Image.read('circles.png');
%     isBinary(img)
%     ans =
%         1
%
%   See also
%     isGrayscale, isVector, isColor
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = strcmp(this.type, 'binary');
