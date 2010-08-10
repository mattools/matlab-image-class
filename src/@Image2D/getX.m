function xdata = getX(this)
%GETX Return physical x-coordinate of pixels
%
%   output = getX(input)
%
%   Example
%   getX
%
%   See also
%   getY
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


sx = this.calib.spacing(1);
ox = this.calib.origin(1);

xdata = (0:this.dataSize(1)-1)*sx + ox;
xdata = xdata(ones(this.dataSize(2), 1), :);
