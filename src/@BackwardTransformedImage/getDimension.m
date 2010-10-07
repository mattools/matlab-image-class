function d = getDimension(this)
%GETDIMENSION  Dimension of the transformed image
%
%   D = img.getDimension();
%   Returns the dimension of the inner interpolated image
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

d = this.interpolator.getDimension();
