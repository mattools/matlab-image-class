function grad = evaluate(this, varargin)
%EVALUATE Return gradient evaluated for specified point
%
%   GRAD = evaluate(THIS, POINTS)
%   Where POINTS is a N-by-3 array, return a N-by-3 array of gradients.
%
%   GRAD = evaluate(THIS, PX, PY, PZ)
%   Where PX, PY and PZ are arrays the same size, return an array with one
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

% default filter for gradient: normalized 3D sobel
[sx sy sz] = Image.create3dGradientKernels();

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


% eventually convert inputs to a single nPoints-by-ndims array
[point dim] = ImageFunction.mergeCoordinates(varargin{:});

% Evaluates image value for a given position
coord = this.refImage.pointToContinuousIndex(point);

% number of positions to process
N = size(coord, 1);

% Create default result image
grad = ones([N 3]) * this.fillValue;

% extract x and y
xt = coord(:, 1);
yt = coord(:, 2);
zt = coord(:, 3);

% select points located inside interpolation area
% (smaller than image physical size)
siz = this.refImage.getSize();
isBefore    = sum(coord<1.5, 2)>0;
isAfter     = sum(coord>=(siz(ones(N,1), :))-.5, 2)>0;
isInside    = ~(isBefore | isAfter);

xt = xt(isInside);
yt = yt(isInside);
zt = zt(isInside);
isInside = reshape(isInside, dim);

% values of the nearest neighbor
inds = find(isInside);
for i=1:length(inds)    
    % indices of pixels before and after in each direction
    i1 = round(xt(i));
    j1 = round(yt(i));
    k1 = round(zt(i));
    
    % create a local copy of the neighborhood
    im = this.refImage(i1-1:i1+1, j1-1:j1+1, k1-1:k1+1);
    % convert to xyz space, and change type
    im = cast(permute(im, [2 1 3]), outputType);
    
    % compute gradients in each main direction
    grad(inds(i), 1) = -sum(sum(sum(im.*sx)));
    grad(inds(i), 2) = -sum(sum(sum(im.*sy)));
    grad(inds(i), 3) = -sum(sum(sum(im.*sz)));
end

