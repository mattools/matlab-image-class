function write(obj, filename, varargin)
% Write image data into specified file.
%
%   write(IMG, FILENAME)
%
%   Example
%     % read a color image and write a new image
%     img = Image.read('peppers.png');
%     img2 = flip(img, 1);
%     write(img2, 'colorImage.tif');
%
%   See also
%     Image/read
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% assumes format can be managed by Matlab Image Processing
imwrite(permute(obj.Data, [2 1 4 3 5]), filename, varargin{:});
