function res = rotate90(this, axis, varargin)
%ROTATE90 Rotate 3D image around by 90 degrees around one of the main axes
%
%   ROTATED = rotate90(IMG, AXIS)
%   Rotate the 3D image around the axis specified by AXIS.
%
%   ROTATED = rotate90(IMG, AXIS, NUMBER)
%   Apply NUMBER rotation around the axis. NUMBER can be +1 or -1.
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

% Error checking
if axis<1 || axis>3
    error('Axis index must be comprised between 1 and 3');
end
    
% positive or negative rotation
n = 1;
if ~isempty(varargin)
    n = varargin{1};
end

% compute indices for rotation
switch axis
    case 1
        % Rotate around X axis
        imInds = [1 3 2];
        if n==1
            permDim = 2;
        else
            permDim = 3;
        end
    case 2
        % Rotate around Y axis
        imInds = [3 2 1];
        if n==1
            permDim = 1;
        else
            permDim = 3;
        end
    case 3
        % Rotate around Z axis
        imInds = [2 1 3];
        if n==1
            permDim = 1;
        else
            permDim = 2;
        end
end

% apply matrix dimension permutation
newData = flipdim(permute(this.data, imInds), permDim);
res = Image3D('data', newData, 'parent', this);

% also permute spacing and origin of image
calib = permute(this.getSpatialCalibration(), imInds);
res.setSpatialCalibration(calib);

