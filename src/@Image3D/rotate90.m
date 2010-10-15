function res = rotate90(this, axis, varargin)
%ROTATE90 Rotate 3D image around by 90 degrees around one of the main axes
%
%   ROTATED = rotate90(IMG, AXIS)
%   Rotate the 3D image around the axis specified by AXIS.
%
%   ROTATED = rotate90(IMG, AXIS, NUMBER)
%   Apply NUMBER rotation around the axis. NUMBER is the number of
%   rotations to apply, between 1 and 3. NUMER can also be negative, in
%   this case the rotation is performed in reverse direction.
%
%
%   Example
%   rotate90
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% error checking
if axis<1 || axis>3
    error('Axis index must be comprised between 1 and 3');
end

% positive or negative rotation
n = 1;
if ~isempty(varargin)
    n = varargin{1};
end

% ensure n is between 0 (no rotation) and 3 (rotation in inverse direction)
n = mod(mod(n, 4) + 4, 4);

% default values
imInds = [1 2 3];
permDim = [];

% compute indices for rotation
switch axis
    case 1
        % Rotate around X axis
        if n==1
            imInds = [1 3 2];
            permDim = 2;
        elseif n==2
            permDim = [2 3];
        elseif n==3
            imInds = [1 3 2];
            permDim = 3;
        end
        
    case 2
        % Rotate around Y axis
        if n==1
            imInds = [3 2 1];
            permDim = 3;
        elseif n==2
            permDim = [1 3];
        elseif n==3
            imInds = [3 2 1];
            permDim = 1;
        end
        
    case 3
        % Rotate around Z axis
        if n==1
            imInds = [2 1 3];
            permDim = 1;
        elseif n==2
            permDim = [1 2];
        elseif n==3
            imInds = [2 1 3];
            permDim = 2;
        end        
end

% apply matrix dimension permutation
newData = permute(this.data, imInds);

% depending on rotation, some dimensions must be fliped
for i=1:length(permDim)
    newData = flipdim(newData, permDim(i));
end

% create the new result image
res = Image3D('data', newData, 'parent', this);

% also permute spacing and origin of image
calib = permute(this.getSpatialCalibration(), imInds);
res.setSpatialCalibration(calib);

