function nd = ndims(obj)
% Return the number of spatial dimension of image.
%
%   N = ndims(IMG);
%   Returns the number of spatial dimensions of the image IMG. This number
%   is comprised between 1 and 3.
%
%   Example
%   % number of dimension of a basic image
%     img = Image2D.read('cameraman.tif');
%     ndims(img)
%     ans =
%         2
%
%   % number of dimension of a color planar image is 2
%     img = Image2D.read('peppers.png');
%     ndims(img)
%     ans = 
%          2
%
%   See also
%      size, elementNumber
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nd = obj.Dimension;