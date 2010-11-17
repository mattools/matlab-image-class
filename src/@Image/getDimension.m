function nd = getDimension(this)
%GETDIMENSION  Number of spatial dimensions of the image
%
%   D = img.getDimension();
%
%   Example
%   img = Image2D.read('cameraman.tif');
%   img.getDimension()
%   ans =
%       2
%
%   See also
%   getSize
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if this.dataSize(3) > 1
    nd = 3;
elseif this.dataSize(2) > 1
    nd = 2;
elseif this.dataSize(1) > 1
    nd = 1;
else
    nd = 0;
end
