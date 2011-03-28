function [val isInside] = evaluateAtIndex(this, varargin)
% Evaluate the value of an image for a point given in image coord

% eventually convert inputs to a single nPoints-by-ndims array
[index dim] = ImageFunction.mergeCoordinates(varargin{:});

val = ones(dim) * this.fillValue;

% extract x and y
xt = index(:, 1);
yt = index(:, 2);

% select points located inside interpolation area
% (smaller than image size)
siz = this.image.getSize();
isInside = ~(xt<1 | yt<1 | xt>=siz(1) | yt>=siz(2));
xt = xt(isInside);
yt = yt(isInside);
isInside = reshape(isInside, dim);

% compute distances to lower-left pixel
i1 = floor(xt);
j1 = floor(yt);

% calcule les distances au bord inferieur bas et gauche
dx = (xt-i1);
dy = (yt-j1);

% values of the 4 pixels around each point
val11 = double(this.image.getPixels(i1, j1)).*(1-dx).*(1-dy);
val21 = double(this.image.getPixels(i1, j1+1)).*(1-dx).*dy;
val12 = double(this.image.getPixels(i1+1, j1)).*dx.*(1-dy);
val22 = double(this.image.getPixels(i1+1, j1+1)).*dx.*dy;

% compute result values
val(isInside) = val11 + val12 + val21 + val22;
