function b = isBinary(obj)
% Checks if an image is binary (only black and white).
%
%   Note: depredated! replaced by "isBinaryImage"
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
%     isBinaryImage
%

% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

warning('Image:deprecated', ...
    'method "isBinary" is deprecated, use "isBinaryImage" instead');

b = strcmp(obj.Type, 'binary');
