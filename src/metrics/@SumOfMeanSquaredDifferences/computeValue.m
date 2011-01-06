function fval = computeValue(this)
%COMPUTEVALUE Compute metric value using current state
%
%   FVAL = this.computeValue()
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
% Created: 2011-01-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


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
    
    res(i) = computeMeanSquaredDifferences(...
        this.images{i1}, this.images{i2}, this.points);
end

% sum of SSD computed over couples
fval = sum(res);


function res = computeMeanSquaredDifferences(img1, img2, points)

% compute values in image 1
[values1 inside1] = img1.evaluate(points);

% compute values in image 2
[values2 inside2] = img2.evaluate(points);

% consider zero outside of images
% TODO: use user-specified default value
outsideValue = 0;
values1(~inside1) = outsideValue;
values2(~inside2) = outsideValue;

% compute squared differences
diff = (values2 - values1).^2;

% Sum of squared differences normalized by number of test points
res = mean(diff);

