function ly = yData(obj)
% Return the vector of positions in the y direction.
%
%   YPOS = yData(IMG);
%   YPOS is a 1-by-Ny row vector, with Ny being the number of elements in
%   the y-direction.
%
%   Example
%   yData
%
%   See also
%     xData, zData
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% extract number of voxels in each dimension
dim = obj.DataSize;

% compute voxel positions
ly = (0:dim(2)-1) * obj.Spacing(2) + obj.Origin(2);
