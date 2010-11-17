function ly = getYPositions(this)
%getYPositions  Return the vector of positions in the y direction
%
%   Deprecated
%   use getYData() instead
%
%   YPOS = this.getYPositions();
%   YPOS is a 1*Ny row vector, with Ny being the number of voxels in the y
%   direction.
%
%   Example
%   getYPositions
%
%   See also
%   getXPositions
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

warning('oolip:deprecated', 'method is deprecated, use getYData instead');

% spacing and origin in y direction
sy = this.calib.spacing(2);
oy = this.calib.origin(2);

% extract number of voxels in each dimension
dim = this.dataSize;

% compute voxel positions
ly = (0:dim(2))*sy + oy;
