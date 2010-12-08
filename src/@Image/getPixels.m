 function p = getPixels(this, x, y, varargin)
% Return pixel array in an image
%
%   P = IMG.getPixels(X, Y)
%   X is column index, Y is row index, both 1-indexed.
%   Result P has the same size as X and Y, and the same class as the data
%   array.
%   
%   P = IMG.getPixels(X, Y, Z)
%   Get values of a 3D image. X, Y and Z must have the same size.
%
%   If IMG is a vector image, the result has one extra dimension at the
%   end.
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Plaform.

% compute size and number of dimensions of input array, between 1 and 3
dim = size(x);
while ~isempty(dim) && dim(end) == 1
    dim = dim(1:end-1);
end
if isempty(dim)
    dim = 1;
end

% extract slice index, or throw an error if not specified for 3D image
z = 1;
if ~isempty(varargin)
    z = varargin{1};
else
    if this.dataSize(3) > 1
        error('Need to specify z index');
    end
end

% precomputation of sub array size
rowSize = this.dataSize(1);
sliceSize = this.dataSize(1)*this.dataSize(2);

nc = size(this.data, 4);
if nc == 1
    % case of grayscale images
    p = zeros(size(x), class(this.data));
    p(:) = this.data((z-1)*sliceSize + (y-1)*rowSize + x);
else
    % number of (spatial) elements
    ne = numel(x);
    volSize = prod(this.dataSize(1:3));

    % compute size of result
    dim2 = [dim nc];
    
    % allocate memory
    p = zeros(dim2, class(this.data));
    
    % iterate over channels to fill result array
    for c = 1:nc
        p((0:ne-1) + (c-1)*ne + 1) = this.data((c-1)*volSize + ...
            (z-1)*sliceSize + (y-1)*rowSize + x);
    end
end
