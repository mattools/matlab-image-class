function varargout = isosurface(obj, isovalue, varargin)
% Generate isosurface of a 3D image.
%
%   isosurface(IMG, ISOVALUE)
%   Computes isosurface from image data and the specified isovalue. 
%   The functions simply consists in a wrapper to the "isosurface" function
%   from Matlab.
%
%   Example
%   isosurface
%
%   See also
%     gt
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-12-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% retrieve voxel coordinates in physical space
x = getX(obj);
y = getY(obj);
z = getZ(obj);

% permute data to comply with Matlab orientation
v = permute(obj.Data(:,:,:,1,1), [2 1 3]);

if nargout == 0
    % display isosurface
    isosurface(x, y, z, v, isovalue, varargin{:});
    
else
    % compute isosurface, and return result in varargout
    varargout = cell(1, nargout);
    [varargout{:}] = isosurface(x, y, z, v, isovalue, varargin{:});
end
