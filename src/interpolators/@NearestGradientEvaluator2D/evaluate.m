function grad = evaluate(this, varargin)
%EVALUATE Return gradient evaluated for specified point
%
%   GRAD = evaluate(THIS, POINTS)
%   Where POINTS is a N-by-2 array, return a N-by-2 array of gradients.
%
%   GRAD = evaluate(THIS, PX, PY)
%   Where PX and PY are arrays the same size, return an array with one
%   dimension more that PX, containing gradient for each point.
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

% default filter for gradient: normalized sobel
sx = fspecial('sobel')'/8;

% default output type
outputType = 'double';

% Process input arguments
for i=1:length(varargin)-1
    if strcmp(varargin{i}, 'filter')
        % another kernel for computing gradient was proposed
        sx = varargin{i+1};
        varargin(i:i+1) = [];
        continue;
        
    elseif strcmp(varargin{i}, 'outputType')
        % change data type of resulting gradient
        outputType = varargin{i+1};
        varargin(i:i+1) = [];
        continue;
    end    
end

% precompute kernels for other directions
sy = sx';

% eventually convert inputs to a single nPoints-by-ndims array
[point dim] = ImageFunction.mergeCoordinates(varargin{:});

% Evaluates image value for a given position
coord = this.refImage.pointToContinuousIndex(point);

% number of positions to process
N = size(coord, 1);

% Create default result image
defaultValue = NaN;
grad = ones([N 2])*defaultValue;

% extract x and y
xt = coord(:, 1);
yt = coord(:, 2);

% select points located inside interpolation area
% (smaller than image physical size)
siz = this.refImage.getSize();
isBefore    = sum(coord<1.5, 2)>0;
isAfter     = sum(coord>=(siz(ones(N,1), :))-.5, 2)>0;
isInside    = ~(isBefore | isAfter);

xt = xt(isInside);
yt = yt(isInside);
isInside = reshape(isInside, dim);

% values of the nearest neighbor
inds = find(isInside);
for i=1:length(inds)    
    % indices of pixels before and after in each direction
    i1 = round(xt(i));
    j1 = round(yt(i));
     
    % create a local copy of the neighborhood
    im = cast(this.refImage(i1-1:i1+1, j1-1:j1+1), outputType);
    
    % compute gradients in each main direction
    grad(inds(i), 1) = -sum(sum(sum(im.*sx)));
    grad(inds(i), 2) = -sum(sum(sum(im.*sy)));
end

