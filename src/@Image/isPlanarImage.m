function b = isPlanarImage(this)
%ISPLANARIMAGE Checks if an image is planar (2D)
%
%   B = isPlanarImage(IMG)
%
%   Example
%     img = Image.read('cameraman.tif');
%     isPlanarImage(img);
%
%   See also
%     is3d, ndims, size
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = this.dimension == 2;
