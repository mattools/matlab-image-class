function [val isInside] = evaluate(this, varargin)
% Evaluate intensity of image at a given physical position
%
% VAL = INTERP.evaluate(POS);
% where POS is a Nx2 array containing alues of x- and y-coordinates
% of positions to evaluate image, return an array with as many
% values as POS.
%
% VAL = INTERP.evaluate(X, Y)
% X and Y should be the same size. The result VAL has the same size
% as X and Y.
%
% [VAL INSIDE] = INTERP.evaluate(...)
% Also return a boolean flag the same size as VAL indicating
% whether or not the given position as located inside the
% evaluation frame.
%


% eventually convert inputs to a single nPoints-by-ndims array
[point dim] = ImageFunction.mergeCoordinates(varargin{:});

% Evaluates image value for a given position
coord = this.image.pointToContinuousIndex(point);

% Create default result image
val = ones(dim) * this.fillValue;

% number of positions to process
N = size(coord, 1);

% extract x and y
xt = coord(:, 1);
yt = coord(:, 2);
zt = coord(:, 3);

% select points located inside interpolation area
% (smaller than image physical size)
siz = this.image.getSize();
isBefore    = sum(coord < 1, 2) > 0;
isAfter     = sum(coord >= (siz(ones(N,1), :)), 2) > 0;
isInside    = ~(isBefore | isAfter);
isInside    = reshape(isInside, dim);

% keep only valid indices for computation
xt = xt(isInside);
yt = yt(isInside);
zt = zt(isInside);

% indices of pixels before in each direction
i1 = floor(xt);
j1 = floor(yt);
k1 = floor(zt);

% compute distances to lower-left pixel
dx = (xt-i1);
dy = (yt-j1);
dz = (zt-k1);

dxi = 1 - dx;
dyi = 1 - dy;
dzi = 1 - dz;

% image sizes
siz     = this.image.getSize();
dimX    = siz(1);
dimXY   = siz(1) * siz(2);

inds    = (k1 - 1) * dimXY + (j1 - 1) * dimX + i1;

% values of the 4 pixels around each point
val111 = double(this.image.data(inds))          .*dxi   .* dyi  .* dzi;
val121 = double(this.image.data(inds + 1))      .*dx    .* dyi  .* dzi;
val211 = double(this.image.data(inds + dimX))   .*dxi   .* dy   .* dzi;
val221 = double(this.image.data(inds + dimX+1)) .*dx    .* dy   .* dzi;
inds = inds + dimXY;
val112 = double(this.image.data(inds))          .* dxi  .* dyi  .* dz;
val122 = double(this.image.data(inds + 1))      .* dx   .* dyi  .* dz;
val212 = double(this.image.data(inds + dimX))   .* dxi  .* dy   .* dz;
val222 = double(this.image.data(inds + dimX+1)) .* dx   .* dy   .* dz;


% Equivalent to:
% val111 = double(this.image.getPixels(i1, j1, k1)).*(1-dx).*(1-dy).*(1-dz);
% val211 = double(this.image.getPixels(i1, j1+1, k1)).*(1-dx).*dy.*(1-dz);
% val121 = double(this.image.getPixels(i1+1, j1, k1)).*dx.*(1-dy).*(1-dz);
% val221 = double(this.image.getPixels(i1+1, j1+1, k1)).*dx.*dy.*(1-dz);
% val112 = double(this.image.getPixels(i1, j1, k1+1)).*(1-dx).*(1-dy).*dz;
% val212 = double(this.image.getPixels(i1, j1+1, k1+1)).*(1-dx).*dy.*dz;
% val122 = double(this.image.getPixels(i1+1, j1, k1+1)).*dx.*(1-dy).*dz;
% val222 = double(this.image.getPixels(i1+1, j1+1, k1+1)).*dx.*dy.*dz;

% compute result values
val(isInside) = ...
    val111 + val121 + val211 + val221 + ...
    val112 + val122 + val212 + val222;
