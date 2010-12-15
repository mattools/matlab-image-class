function ly = getYData(this)
%GETYDATA  Return the vector of positions in the y direction
%
%   YPOS = this.getYData();
%   YPOS is a 1*Ny row vector, with Ny being the number of voxels in the y
%   direction.
%
%   Example
%   getYData
%
%   See also
%   getXData, getZData
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
ly = (0:dim(2)-1)*this.spacing(2) + this.origin(2);
