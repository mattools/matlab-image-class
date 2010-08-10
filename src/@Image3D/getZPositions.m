function lz = getZPositions(this)
%getZPositions  Return the vector of positions in the z direction
%
%   ZPO = this.getZPositions();
%   ZPOS is a 1*Nz row vector, with Nz being the number of voxels in the z
%   direction.
%
%   Example
%   getZPositions
%
%   See also
%   getXPositions, getYPositions
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% extract number of voxels in each dimension
dim = this.dataSize;

% compute voxel positions
lz = (0:dim(3))*this.calib.spacing(3) + this.calib.origin(3);
