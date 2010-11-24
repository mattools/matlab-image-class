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

% compute distances to lower-left pixel
i1 = floor(xt);
j1 = floor(yt);
k1 = floor(zt);

% calcule les distances au bord inferieur bas et gauche
dx = (xt-i1);
dy = (yt-j1);
dz = (zt-k1);

% values of the 4 pixels around each point
val111 = double(this.image.getPixels(i1, j1, k1)).*(1-dx).*(1-dy).*(1-dz);
val211 = double(this.image.getPixels(i1, j1+1, k1)).*(1-dx).*dy.*(1-dz);
val121 = double(this.image.getPixels(i1+1, j1, k1)).*dx.*(1-dy).*(1-dz);
val221 = double(this.image.getPixels(i1+1, j1+1, k1)).*dx.*dy.*(1-dz);
val112 = double(this.image.getPixels(i1, j1, k1+1)).*(1-dx).*(1-dy).*dz;
val212 = double(this.image.getPixels(i1, j1+1, k1+1)).*(1-dx).*dy.*dz;
val122 = double(this.image.getPixels(i1+1, j1, k1+1)).*dx.*(1-dy).*dz;
val222 = double(this.image.getPixels(i1+1, j1+1, k1+1)).*dx.*dy.*dz;

% compute result values
val(isInside) = ...
    val111 + val121 + val211 + val221 + ...
    val112 + val122 + val212 + val222;
