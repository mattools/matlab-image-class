function [perim, labels] = regionPerimeter(obj, varargin)
% Perimeter of regions within a 2D binary or label image.
%
%   P = imPerimeter(IMG);
%   Return an estimate of the perimeter of the image, computed by
%   counting intersections with 2D lines, and using discretized version of
%   the Crofton formula.
%
%   P = imPerimeter(IMG, NDIRS);
%   Specify number of directions to use. Use either 2 or 4 (the default).
%
%   [P, LABELS] = imPerimeter(LBL, ...)
%   Process a label image, and return also the labels for which a value was
%   computed.
%
%   Example
%     % compute the perimeter of a binary disk of radius 40
%     lx = 1:100; ly = 1:100;
%     [x, y] = meshgrid(lx, ly);
%     img = Image(hypot(x - 50.12, y - 50.23) < 40);
%     regionPerimeter(img)
%     ans =
%         251.1751
%     % to be compared to (2 * pi * 40), approximately 251.3274
%
%   See also
%     regionArea, regionEulerNumber, regionSurfaceArea, regionprops
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-11-02,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE.


%% Parse input arguments

% check image type
if ~(isLabelImage(obj) || isBinaryImage(obj))
    error('Requires a label of binary image');
end

% check dimensionality
nd = ndims(obj);
if nd ~= 2
    error('Requires a 2-dimensional image');
end

% default values of parameters
nDirs = 4;
%delta = [1 1];
labels = [];

% parse parameter name-value pairs
while ~isempty(varargin)
    var1 = varargin{1};
    
    if isnumeric(var1)
        % option can be number of directions, or list of labels
        if isscalar(var1)
            nDirs = var1;
        elseif size(var1, 2) == 1
            labels = var1;
        end
        varargin(1) = [];
        
    elseif ischar(var1)
        if length(varargin) < 2
            error('Parameter name must be followed by parameter value');
        end
        
        if strcmpi(var1, 'ndirs')
            nDirs = varargin{2};
        elseif strcmpi(var1, 'Labels')
            labels = var1;
        else
            error(['Unknown parameter name: ' var1]);
        end
        
        varargin(1:2) = [];
    end
end


%% Process label images

if isBinaryImage(obj)
    % in case of binary image, compute only one label
    perim = perimeterBinaryData(obj.Data, nDirs, obj.Spacing);
    labels = 1;
    
else
    % in case of a label image, return a vector with a set of results
    
    % extract labels if necessary (considers 0 as background)
    if isempty(labels)
        labels = findRegionLabels(obj);
    end
    
    % allocate result array
    nLabels = length(labels);
    perim = zeros(nLabels, 1);
    
    % compute bounding box of each region
    bounds = regionMinMaxIndices(obj, labels);
    
    % compute perimeter of each region considered as binary image
    for i = 1:nLabels
        label = labels(i);
        
        % convert bounding box to image extent, in x and y directions
        bx = bounds(i, [1 2]);
        by = bounds(i, [3 4]);
        
        bin = obj.Data(bx(1):bx(2), by(1):by(2)) == label;
        perim(i) = perimeterBinaryData(bin, nDirs, obj.Spacing);
    end
end


%% Process 2D binary image
function perim = perimeterBinaryData(img, nDirs, spacing)

%% Initialisations 

% distances between a pixel and its neighbours (orthogonal, and diagonal)
% (d1 is dx, d2 is dy)
d1  = spacing(1);
d2  = spacing(2);
d12 = hypot(d1, d2);

% area of a pixel (used for computing line densities)
vol = d1 * d2;

% size of image
D1  = size(img, 1);
D2  = size(img, 2);


%% Processing for 2 or 4 main directions

% compute number of pixels, equal to the total number of vertices in graph
% reconstructions 
nv = sum(img(:));

% compute number of connected components along orthogonal lines
% (Use Graph-based formula: chi = nVertices - nEdges)
n1 = nv - sum(sum(img(1:D1-1, :) & img(2:D1, :)));
n2 = nv - sum(sum(img(:, 1:D2-1) & img(:, 2:D2)));

% Compute perimeter using 2 directions
% equivalent to:
% perim = mean([n1/(d1/a) n2/(d2/a)]) * pi/2;
% with a = d1*d2 being the area of the unit tile
if nDirs == 2
    perim = pi * mean([n1*d2 n2*d1]);
    return;
end


%% Processing specific to 4 directions

% Number of connected components along diagonal lines
n3 = nv - sum(sum(img(1:D1-1, 1:D2-1) & img(2:D1,   2:D2)));
n4 = nv - sum(sum(img(1:D1-1, 2:D2  ) & img(2:D1, 1:D2-1)));

% compute direction weights (necessary for anisotropic case)
if any(d1 ~= d2)
    c = computeDirectionWeights2d4([d1 d2])';
else
    c = [1 1 1 1] * 0.25;
end

% compute weighted average over directions
perim = pi * sum( [n1/d1 n2/d2 n3/d12 n4/d12] * vol .* c );


%% Compute direction weights for 4 directions
function c = computeDirectionWeights2d4(delta)
%COMPUTEDIRECTIONWEIGHTS2D4 Direction weights for 4 directions in 2D
%
%   C = computeDirectionWeights2d4
%   Returns an array of 4-by-1 values, corresponding to directions:
%   [+1  0]
%   [ 0 +1]
%   [+1 +1]
%   [-1 +1]
%
%   C = computeDirectionWeights2d4(DELTA)
%   With DELTA = [DX DY].
%
%   Example
%   computeDirectionWeights2d4
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% check case of empty argument
if nargin == 0
    delta = [1 1];
end

% angle of the diagonal
theta   = atan2(delta(2), delta(1));

% angular sector for direction 1 ([1 0])
alpha1  = theta;

% angular sector for direction 2 ([0 1])
alpha2  = (pi/2 - theta);

% angular sector for directions 3 and 4 ([1 1] and [-1 1])
alpha34 = pi/4;

% concatenate the different weights
c = [alpha1 alpha2 alpha34 alpha34]' / pi;

