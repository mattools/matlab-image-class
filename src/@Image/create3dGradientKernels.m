function [sx sy sz] = create3dGradientKernels(varargin)
%CREATE3DGRADIENTKERNELS Create kernels for computing gradient of 3D images 
%
%   SX = Image.create3dGradientKernels;
%   [SX SY SZ] = Image.create3dGradientKernels;
%
%   Example
%
%   See also
%   gradient
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% default filter for gradient: normalized 3D Sobel
base = [1 2 1]'*[1 2 1];
base = base/sum(base(:))/2;
sx = permute(cat(3, base, zeros(3, 3), -base), [3 1 2]);

if nargout>1
    % precompute kernels for other directions
    sy = permute(sx, [3 1 2]);
    sz = permute(sx, [2 3 1]);
end