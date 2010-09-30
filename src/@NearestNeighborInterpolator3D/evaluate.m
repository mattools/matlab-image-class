function [val isInside] = evaluate(this, point, varargin)
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



% eventually convert inputs from x, y, z to a list of points
dim = [size(point,1) 1];
if length(varargin)>1
    var1 = varargin{1};
    var2 = varargin{2};
    if sum(size(var1)~=size(point))==0
        % keep dimension of original array
        dim = size(point);
        % create a linear array of indices
        point = [point(:) var1(:) var2(:)];
    end
end

% Evaluates image value for a given position
coord = this.image.pointToContinuousIndex(point);

% Create default result image
defaultValue = NaN;
val = ones(dim)*defaultValue;

% number of positions to process
N = size(coord, 1);

% extract x and y
xt = coord(:, 1);
yt = coord(:, 2);
zt = coord(:, 3);

% select points located inside interpolation area
% (smaller than image physical size)
siz = this.image.getSize();
isBefore    = sum(coord<.5, 2)>0;
isAfter     = sum(coord>=(siz(ones(N,1), :))+.5, 2)>0;
isInside    = ~(isBefore | isAfter);

xt = xt(isInside);
yt = yt(isInside);
zt = zt(isInside);
isInside = reshape(isInside, dim);

% indices of pixels before and after in each direction
i1 = round(xt);
j1 = round(yt);
k1 = round(zt);

% values of the nearest neighbor
val(isInside) = double(this.image.getPixels(i1, j1, k1));

