function b = is3dImage(this)
%IS3DIMAGE Checks if an image is 3D
%
%   B = is3dImage(IMG)
%
%   Example
%     img = Image.read('cameraman.tif');
%     is3dImage(img);
%     ans =
%         0
%
%     % read a 3D image
%     img = Image.read('brainMRI.hdr');
%     is3dImage(img)
%     ans =
%         1
%
%
%   See also
%     isPlanarImage, ndims, size
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-09-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = this.dimension == 3;
