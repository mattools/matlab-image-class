function rgb = double2rgb(obj, map, bounds, varargin)
% Create a RGB image from values of an intensity image.
%
%   RGB = double2rgb(IMG, MAP, BOUNDS)
%   Scales the values in IMG between in the interval specified by BOUNDS,
%   then convert each value to the corresponding value of the color map
%   given in MAP.
%   If the image contains inf or NaN values, they are set to white.
%
%   RGB = double2rgb(IMG, MAP)
%   Assumes extreme values are given by extreme values in image. Only
%   finite values are used for computing bounds.
%
%   RGB = double2rgb(IMG, MAP, BOUNDS, BACKGROUND)
%   Specifies the value of the background value for Nan and Inf values in
%   IMG. BACKGROUND should be either a 1-by-3 row vector with values
%   between 0 and 1, or one of the color shortcuts 'r', 'b', 'g', 'c', 'y',
%   'm', 'k', 'w'.
%
%   Example
%   % Distance map of a binary image
%     img = Image.read('circles.png');
%     dist = distanceMap(invert(img));
%     dist(img) = NaN;
%     rgb = double2rgb(dist, 'parula', [], 'w');
%     show(rgb);
% 
%   See also
%     label2rgb, rgb2hsv
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-01-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% HISTORY

if nargin < 2 || isempty(map)
    map = 'parula';
end

% ensure map is a numeric array
if ischar(map)
    map = feval(map, 256); %#ok<FVAL>
end

% extract background value
bgColor = [1 1 1];
if ~isempty(varargin)
    bgColor = parseColor(varargin{1});
end

% get valid pixels (finite value)
valid = isfinite(obj.Data);
if ~exist('bounds', 'var') || isempty(bounds)
    bounds = [min(obj.Data(valid)) max(obj.Data(valid))];
end

% convert finite values to indices between 1 and map length
n = size(map, 1);
inds = (obj.Data(valid) - bounds(1)) / (bounds(end) - bounds(1)) * (n-1);
inds = floor(min(max(inds, 0), n-1))+1;

% compute the 3 bands
dim = size(obj);
r = ones(dim) * bgColor(1); r(valid) = map(inds, 1);
g = ones(dim) * bgColor(2); g(valid) = map(inds, 2);
b = ones(dim) * bgColor(3); b(valid) = map(inds, 3);

% concatenate the 3 bands to form an rgb image
if length(dim) == 2
    % case of 2D image
    rgb = cat(3, r, g, b);
    
else
    % case of 3D image: need to play with channels
    dim2 = [dim(1:2) 3 dim(3:end)];
    rgb = zeros(dim2, class(map));
    rgb(:,:,1,:) = r;
    rgb(:,:,2,:) = g;
    rgb(:,:,3,:) = b;
end

% create result array
data = permute(rgb, [2 1 3 4:length(dim)]);

% create Image object from data
name = createNewName(obj, '%s-rgb');
rgb = Image(data, 'Type', 'color', ...
    'Parent', obj, ...
    'Name', name);

function color = parseColor(color)

if ischar(color)
    switch(color)
        case 'k'
            color = [0 0 0];
        case 'w'
            color = [1 1 1];
        case 'r'
            color = [1 0 0];
        case 'g'
            color = [0 1 0];
        case 'b'
            color = [0 0 1];
        case 'c'
            color = [0 1 1];
        case 'm'
            color = [1 0 1];
        case 'y'
            color = [1 1 0];
        otherwise 
            error('Unknown color string');
    end
end
