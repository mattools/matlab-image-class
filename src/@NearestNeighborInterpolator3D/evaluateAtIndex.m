function [val isInside] = evaluateAtIndex(this, varargin)
% Evaluate the value of an image for a point given in image coord

% eventually convert inputs to a single nPoints-by-ndims array
[index dim] = ImageFunction.mergeCoordinates(varargin{:});

% number of positions to process
N = size(index, 1);

% initialize result with default value
val = ones(dim)*NaN;

% extract x and y
xt = index(:, 1);
yt = index(:, 2);
zt = index(:, 3);

% select points located inside interpolation area
% (smaller than image size)
siz = this.image.getSize();
isBefore    = sum(index<1, 2)<0;
isAfter     = sum(index>=(siz(ones(N,1), :)), 2)>0;
isInside = ~(isBefore | isAfter);
isInside = reshape(isInside, dim);

% keep only valid indices for computation
xt = xt(isInside);
yt = yt(isInside);
zt = zt(isInside);

% indices of pixels before and after in each direction
i1 = round(xt);
j1 = round(yt);
k1 = round(zt);

% values of the nearest neighbor
val(isInside) = double(this.image.getPixels(i1, j1, k1));
