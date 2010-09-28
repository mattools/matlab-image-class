function lx = getXData(this)
%GETXDATA  Return the vector of positions in the x direction
%
%   XPOS = this.getXData();
%   XPOS is a 1*Nx row vector, with Nx being the number of voxels in the x
%   direction.
%
%   Example
%   getXData
%
%   See also
%   getYData, getZData
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
lx = (0:dim(1)-1)*this.calib.spacing(1) + this.calib.origin(1);
