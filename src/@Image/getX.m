function xdata = getX(obj)
% Returns physical x-coordinate of voxels.
%
%   ZDATA = getX(IMG)
%
%   Example
%   getX
%
%   See also
%     getY, getZ
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

siz = obj.DataSize(1:3);
xdata = (0:siz(1)-1)*obj.Spacing(1) + obj.Origin(1);
xdata = xdata(ones(siz(2), 1), :, ones(siz(3), 1));

