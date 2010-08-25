function d = getDimension(this) %#ok<INUSD>
%GETDIMENSION  Dimension of the interpolated image
%
%   D = img.getDimension();
%
%   Example
%   img = Image2D.read('cameraman.tif');
%   interp = LinearInterpolator2D.create(img);
%   interp.getDimension()
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

d = 2;
