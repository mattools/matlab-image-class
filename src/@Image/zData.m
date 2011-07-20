function lz = zData(this)
%ZDATA Return the vector of positions in the z direction
%
%   ZPOS = zData(IMG);
%   ZPOS is a 1-by-Nz row vector, with Nz being the number of elements in
%   the z-direction. 
%
%   Example
%   zData
%
%   See also
%   xData, yData
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% extract number of voxels in each dimension
dim = this.dataSize;

% compute voxel positions
lz = (0:dim(3)-1) * this.spacing(3) + this.origin(3);
