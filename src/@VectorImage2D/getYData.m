function ly = getYData(this)
%GETYDATA  Return the vector of positions in the y direction
%
%   YPOS = this.getYData();
%   YPOS is a 1*Ny row vector, with Ny being the number of pixels in the y
%   direction.
%
%   Example
%   getYData
%
%   See also
%   getXData
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% spacing and origin in y direction
sy = this.calib.spacing(2);
oy = this.calib.origin(2);

% extract number of voxels in each dimension
dim = this.dataSize;

% compute voxel positions
ly = (0:dim(2)-1)*sy + oy;
