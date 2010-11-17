function ydata = getY(this)
%GETX Return physical y-coordinate of pixels
%
%   Usage
%   y = img.getY()
%
%   Example
%   getY
%
%   See also
%   getX
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


sy = this.calib.spacing(2);
oy = this.calib.origin(2);

ydata = (0:this.dataSize(2)-1)'*sy + oy;
ydata = ydata(:, ones(this.dataSize(1), 1));
