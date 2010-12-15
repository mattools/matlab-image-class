function xdata = getX(this)
%GETX  Returns physical x-coordinate of voxels
%
%   output = getX(input)
%
%   Example
%   getX
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

siz = this.dataSize(1:3);
xdata = (0:siz(1)-1)*this.spacing(1) + this.origin(1);
xdata = xdata(ones(siz(2), 1), :, ones(siz(3), 1));

