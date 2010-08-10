function ly = getYPositions(this)
%getYPositions  Return the vector of positions in the y direction
%
%   YPOS = this.getYPositions();
%   YPOS is a 1*Ny row vector, with Ny being the number of voxels in the y
%   direction.
%
%   Example
%   getYPositions
%
%   See also
%   getXPositions, getZPositions
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% extract number of voxels in each dimension
dim = this.dataSize;

% compute voxel positions
ly = (0:dim(2))*this.calib.spacing(2) + this.calib.origin(2);
