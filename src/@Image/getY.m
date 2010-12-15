function ydata = getY(this)
%GETY  Returns physical y-coordinate of voxels
%
%   output = getY(input)
%
%   Example
%   getY
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

siz = this.dataSize;
ydata = (0:siz(2)-1)*this.spacing(2) + this.origin(2);
ydata = reshape(ydata, [siz(2) 1 1]);
ydata = ydata(:, ones(siz(1), 1), ones(siz(3), 1));
