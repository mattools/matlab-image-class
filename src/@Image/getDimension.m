function d = getDimension(this)
%GETDIMENSION  Dimension of the image
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

d = length(this.dataSize);
