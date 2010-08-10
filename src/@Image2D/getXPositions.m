function lx = getXPositions(this)
%GETXPOSITIONS  Return the vector of positions in the x direction
%
%   XPOS = this.getXPositions();
%   XPOS is a 1*Nx row vector, with Nx being the number of voxels in the x
%   direction.
%
%   Example
%   getXPositions
%
%   See also
%   getYPositions
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% spacing and origin in x direction
sx = this.calib.spacing(1);
ox = this.calib.origin(1);

% extract number of voxels in each dimension
dim = this.dataSize;

% compute voxel positions
lx = (0:dim(1))*sx + ox;
