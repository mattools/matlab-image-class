function s = size(this, dim)
%SIZE Return image size
%
%   S = size(IMG);
%   Return the size of the image in the spatial dimensions.
%
%   S = size(IMG, DIM);
%   Return the size of the image in a given dimension:
%   size(IMG, 1) returns the number of columns  ("X" direction)
%   size(IMG, 2) returns the number of rows     ("Y" direction)
%   size(IMG, 3) returns the number of slices   ("Z" direction)
%   size(IMG, 4) returns the number of channels ("C" direction)
%   size(IMG, 5) returns the number of frames   ("T" direction)
%
%   Examples
%   img = Image.read('cameraman.tif');
%   size(img)
%   ans =
%        256   256
%
%   img = Image.read('peppers.png');
%   size(img, 4)
%   ans =
%        3
%
%
%   See also
%   Image/ndims
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if nargin == 1
    s = this.dataSize(1:this.dimension);
else
    s = this.dataSize(dim);
end
