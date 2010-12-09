function [val isInside] = evaluate(this, varargin)
% Evaluate intensity of image at a given physical position
%
%   VAL = INTERP.evaluate(POS);
%   where POS is a N-by-2 or N-by-3 array containing values of x-, y-, and
%   eventually z-coordinates of positions to evaluate image, returns a
%   column array with as many rows as the number of rows in POS.
%
%   VAL = INTERP.evaluate(X, Y)
%   VAL = INTERP.evaluate(X, Y, Z)
%   X, Y and Z should be the same size. The result VAL has the same size as
%   X and Y. 
%  
%
%   [VAL INSIDE] = INTERP.evaluate(...)
%   Also return a boolean flag the same size as VAL indicating whether or
%   not the given position as located inside the evaluation frame.
%

% value for pixels outside interpolation frame
defaultValue = NaN;

% number of dimensions of base image
nd = this.image.getDimension();

% size of elements: number of channels by number of frames
elSize = this.image.getElementSize();


% eventually convert inputs to a single nPoints-by-ndims array
[point dim] = ImageFunction.mergeCoordinates(varargin{:});

if size(point, 2) ~= nd
    error('Dimension of input positions should be the same as image');
end

% Evaluates image value for a given position
coord = this.image.pointToContinuousIndex(point);


% size and number of dimension of input coordinates
dim0 = dim;
if dim0(end) == 1
    dim0 = dim0(1:end-1);
end
resNDim = length(dim0);

% Create default result image
dim2 = [dim0 elSize];
val = ones(dim2)*defaultValue;

% extract x and y
xt = coord(:, 1);
yt = coord(:, 2);
if nd > 2
    zt = coord(:, 3);
end

% number of positions to process
N = size(coord, 1);

% select points located inside interpolation area
% (smaller than image physical size)
siz = this.image.getSize();
isBefore    = sum(coord < .5, 2)>0;
isAfter     = sum(coord >= (siz(ones(N,1), :))+.5, 2)>0;
isInside    = ~(isBefore | isAfter);

xt = xt(isInside);
yt = yt(isInside);
isInside = reshape(isInside, dim);

% indices of pixels before and after in each direction
i1 = round(xt);
j1 = round(yt);
if nd > 2
    zt = zt(isInside);
    k1 = round(zt);
end

% values of the nearest neighbor
if prod(elSize) == 1
    % case of scalar image elements (no vector image, no movie image)
    if nd == 2
        val(isInside) = double(this.image.getPixels(i1, j1));
    else
        val(isInside) = double(this.image.getPixels(i1, j1, k1));
    end
else
    % If dimension number of elements is >1, need more processing.
    
    % compute interpolated values
    if nd == 2
        res = double(this.image.getPixels(i1, j1));
    else
        res = double(this.image.getPixels(i1, j1, k1));
    end
    
    % compute spatial index of each interpolated point
    subs = cell(1, resNDim);
    [subs{:}] = ind2sub(dim, find(isInside));
    
    % pre-compute some indices of interpolated values
    subs2 = num2cell(ones(1, length(dim2)));
    subs2{resNDim+1} = 1:elSize(1);
    subs2{resNDim+2} = 1:elSize(2);
    
    % iterate on interpolated values
    for i = 1:length(subs{1})
        % compute matrix indices of interpolated value
        for d = 1:resNDim
            subInds = subs{d};
            subs2{d} = subInds(i);
        end
        
        % places components of interpolated value at the right loaction
        val(subs2{:}) = res(i, :);
    end
end

