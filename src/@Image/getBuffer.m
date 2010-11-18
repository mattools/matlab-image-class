function dat = getBuffer(this)
%GETBUFFER Return data buffer using matlab index convention
%
%   DATA = getBuffer(IMG)
%   For 2D images, DATA is a Ny-by-Nx-by-Nc array.
%   For 3D images, DATA is a Ny-by-Nx-by-Nz or Ny-by-Nx-by-Nc-by-Nz array,
%   depending if image is a scalar or vector image.
%
%
%   Example
%   getBuffer
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

dat = squeeze(permute(this.data, [2 1 4 3 5]));