function [grad isInside]= evaluate(this, varargin)
%EVALUATE Return gradient evaluated for specified point
%
%   GRAD = evaluate(THIS, POINTS)
%   Where POINTS is a N-by-2 array, return a N-by-2 array of gradients.
%
%   GRAD = evaluate(THIS, PX, PY)
%   Where PX and PY are arrays the same size, return an array with one
%   dimension more that PX, containing gradient for each point.
%
%   [GRAD ISINSIDE] = evaluate(...)
%   Also returns an array of boolean indicating which points are within the
%   image frame.
%
%   Example
%   evaluate
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% number of dimensions of base image
nd = this.image.getDimension();

% size of elements: number of channels by number of frames
elSize = this.image.getElementSize();
if elSize(1) > 1
    error('Can not evaluate gradient of a vector image');
end 

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

% number of positions to process
N = size(coord, 1);

% Create default result image
dim2 = [dim0 nd];
grad = ones(dim2) * this.fillValue;

% % Create default result image
% defaultValue = NaN;
% grad = ones([N 2])*defaultValue;

% extract x and y
xt = coord(:, 1);
yt = coord(:, 2);
if nd > 2
    zt = coord(:, 3);
end

% select points located inside interpolation area
% (smaller than image physical size)
siz = this.image.getSize();
isBefore    = sum(coord < 1.5, 2) > 0;
isAfter     = sum(coord >= (siz(ones(N,1), :))-.5, 2) > 0;
%isAfter     = sum(bsxfun(@ge, coord, siz + .5), 2) > 0;
isInside    = ~(isBefore | isAfter);

xt = xt(isInside);
yt = yt(isInside);
if nd > 2
    zt = zt(isInside);
end
isInside = reshape(isInside, dim);

% convert to indices
inds = find(isInside);

if length(this.filters) < nd
    error('Wrong initialization of gradient filters');
end

% values of the nearest neighbor
if nd == 2
    sx = this.filters{1};
    sy = this.filters{2};
    
    for i=1:length(inds)    
        % indices of pixels before and after in each direction
        i1 = round(xt(i));
        j1 = round(yt(i));
       
        % create a local copy of the neighborhood
        im = cast(this.image(i1-1:i1+1, j1-1:j1+1), this.outputType);

        % compute gradients in each main direction
        grad(inds(i), 1) = -sum(sum(sum(im.*sx)));
        grad(inds(i), 2) = -sum(sum(sum(im.*sy)));
    end

else
    sx = this.filters{1};
    sy = this.filters{2};
    sz = this.filters{3};

    for i=1:length(inds)    
        % indices of pixels before and after in each direction
        i1 = round(xt(i));
        j1 = round(yt(i));
        k1 = round(zt(i));

        % create a local copy of the neighborhood
        im = cast(permute(this.image(i1-1:i1+1, j1-1:j1+1, k1-1:k1+1), ...
            [2 1 3]), ...
            this.outputType);

        % compute gradients in each main direction
        grad(inds(i), 1) = -sum(sum(sum(im.*sx)));
        grad(inds(i), 2) = -sum(sum(sum(im.*sy)));
        grad(inds(i), 3) = -sum(sum(sum(im.*sz)));
    end
    
end

