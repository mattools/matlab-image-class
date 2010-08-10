function res = computeSSDMetric(img1, img2, points)
%COMPUTESSDMETRIC  One-line description here, please.
%   output = computeSSDMetric(input)
%
%   Example
%   computeSSDMetric
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isa(img1, 'ImageFunction')
    % ok
elseif isa(img1, 'Image')
    % if points are no specified, compute their position from image
    if nargin==2
        x = img1.getX();
        y = img1.getY();
        points = [x(:) y(:)];
    end
    % convert image to interpolator
    img1 = LinearInterpolator2D(img1);
else
    error('First argument must be an image function');
end

if isa(img2, 'ImageFunction')
    % ok
elseif isa(img2, 'Image')
    % convert image to interpolator
    img2 = LinearInterpolator2D(img2);
else
    error('Second argument must be an image function');
end
 
% compute values in image 1
[values1 inside1] = img1.evaluate(points);

% compute values in image 2
[values2 inside2] = img2.evaluate(points);

% keep only valid values
inds = inside1 & inside2;

% compute result
diff = (values2(inds)-values1(inds)).^2;
res = mean(diff);
