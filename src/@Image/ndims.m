function nd = ndims(this)
%NDIMS  Return the number of dimension of image
%
%   n = img.ndims();
%
%   Example
%   img = Image2D.read('cameraman.tif');
%   img.ndims()
%   ans =
%       2
%
%   See also
%   getDimension
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nd = getDimension(this);
