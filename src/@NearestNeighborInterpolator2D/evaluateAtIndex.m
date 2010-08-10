function [val isInside] = evaluateAtIndex(this, index, varargin)
% Evaluate the value of an image for a point given in image coord

% eventually convert inputs from x and y to a list of image coord
dim = [size(index,1) 1];
if ~isempty(varargin)
    var = varargin{1};
    if sum(size(var)~=size(index))==0
        dim = size(index);
        index = [index(:) var(:)];
    end
end

val = ones(dim)*NaN;

% extract x and y
xt = index(:, 1);
yt = index(:, 2);

% select points located inside interpolation area
% (smaller than image size)
siz = this.image.getSize();
isInside = ~(xt<-.5 | yt<-.5 | xt>=siz(1)-.5 | yt>=siz(2)-.5);
xt = xt(isInside);
yt = yt(isInside);
isInside = reshape(isInside, dim);

% indices of pixels before and after in each direction
i1 = round(xt);
j1 = round(yt);

% values of the nearest neighbor
val(isInside) = double(this.image.getPixels(i1, j1));
