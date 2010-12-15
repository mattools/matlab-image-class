function zdata = getZ(this)
%GETZ  Returns physical z-coordinate of voxels
%
%   output = getZ(input)
%
%   Example
%   getZ
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
zdata = (0:siz(3)-1)'*this.spacing(3) + this.origin(3);
zdata = reshape(zdata, [1 1 siz(3)]);
zdata = zdata(ones(siz(2), 1), ones(siz(1),1), :);
