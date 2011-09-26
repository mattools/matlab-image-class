function b = isColor(this)
%ISCOLOR Checks if an image is color
%
%   B = isColor(IMG)
%
%   Example
%     img = Image.read('cameraman.tif');
%     isColor(img)
%     ans =
%         0
%
%     img = Image.read('peppers.png');
%     isColor(img)
%     ans =
%         1
%
%
%   See also
%     isGrayscale, isVector, isBinary
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = strcmp(this.type, 'color');
