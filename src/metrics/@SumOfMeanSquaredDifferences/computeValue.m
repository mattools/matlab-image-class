function val = computeValue(this)
%COMPUTEVALUE Compute metric value 
%
%   output = computeValue(input)
%
%   Example
%   computeValue
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% extract number of images
nImages = length(this.images);

% generate all possible couples of images
combis  = sortrows(combnk(1:nImages, 2));
nCombis = size(combis, 1);

% compute SSD for each image couple
res = zeros(nCombis, 1);
for i=1:nCombis
    i1 = combis(i,1);
    i2 = combis(i,2);
    
    res(i) = computeSSDMetric(this.images{i1}, this.images{i2}, this.points);
end

% sum of SSD computed over couples
val = sum(res);

function res = computeSSDMetric(img1, img2, points)

% compute values in image 1
[values1 inside1] = img1.evaluate(points);

% compute values in image 2
[values2 inside2] = img2.evaluate(points);

% keep only valid values
inds = inside1 & inside2;

% compute result
diff    = (values2(inds) - values1(inds)).^2;
res     = sum(diff) / length(inds);

