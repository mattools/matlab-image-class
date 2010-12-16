function varargout = isosurface(this, isovalue, varargin)
%ISOSURFACE Isosurface generation of a 3D image
%
%   output = isosurface(input)
%
%   Example
%   isosurface
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

x = this.getX();
y = this.getY();
z = this.getZ();

v = permute(this.data(:,:,:,1,1), [2 1 3]);

if nargout==0
    % display isosurface
    isosurface(x, y, z, v, isovalue, varargin{:});
    
else
    varargout = cell(1, nargout);
    varargout{:} = isosurface(x, y, z, v, isovalue, varargin{:});
end
