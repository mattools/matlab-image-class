function lx = xData(this)
%XDATA  Return the vector of positions in the x direction
%
%   XPOS = xData(IMG);
%   XPOS is a 1-by-Nx row vector, with Nx being the number of elements in
%   the x-direction. 
%
%   Example
%   xData
%
%   See also
%   yData, zData
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% extract number of voxels in each dimension
dim = this.dataSize;

% compute voxel positions
lx = (0:dim(1)-1) * this.spacing(1) + this.origin(1);
