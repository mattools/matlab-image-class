function res = dotProduct(this, vec)
%DOTPRODUCT  Compute dot product with a vector or a vector image
%
%   Usage
%   RES = IMG.dotProduct(VEC);
%   RES = IMG.dotProduct(VECIMG);
%   
%   Description
%   RES = IMG.dotProduct(VEC);
%   Computes the dot product of each pixel with the vector VEC. VEC is a
%   row vector with as many elements as the number of components of the
%   vector image IMG.
%   The result RES is a scalar image the same size as IMG.
%
%   RES = IMG.dotProduct(VECIMG);
%   Computes the dot product with each corresponding pixel of the vector
%   image VECIMG. VECIMG should be the same size as IMG.
%
%   Example
%   dotProduct
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% compute data to display
% use vector norm
res = zeros(this.dataSize);
nc = this.getComponentNumber();
for i=1:nc
    res = res + this.data(:,:,i)*vec(i);
end

res = Image2D('data', res, 'parent', this);
