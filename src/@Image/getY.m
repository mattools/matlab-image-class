function ydata = getY(obj)
% Returns physical y-coordinate of voxels.
%
%   ZDATA = getY(IMG)
%
%   Example
%   getY
%
%   See also
%     getX, getZ
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

siz = obj.DataSize;
ydata = (0:siz(2)-1)*obj.Spacing(2) + obj.Origin(2);
ydata = reshape(ydata, [siz(2) 1 1]);
ydata = ydata(:, ones(siz(1), 1), ones(siz(3), 1));
