function [val deriv] = computeValueAndGradient(this)
%COMPUTEVALUE Compute metric value  and gradient
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

res = zeros(1, nImages);

% number of parameters
nParams = this.transforms{1}.getParameterLength();
nTotalParams = nParams * nImages;

% gradient vector for one image
gradSum = zeros(1, nParams);

% gradient vectors for all images
deriv   = zeros(1, nTotalParams);

% loop over first image
for i=1:nImages-1
    img1 = this.images{i};
    
    transfo = this.transforms{i};
    gradient = this.gradients{i};

    % init accululators to 0
    gradSum(:) = 0;
    msdSum  = 0;

    % compare with each one of the other images
    for j = [1:i-1 i+1:nImages]
        img2 = this.images{j};
        [msd grad] = computeMSDWithGrad(img1, img2, this.points, ...
            transfo, gradient);
        gradSum = gradSum + grad;
        msdSum  = msdSum + msd;
    end
    
    % keep in global array
    i1 = (i-1)*nParams+1;
    i2 = i*nParams;
    deriv(i1:i2) = gradSum;

    res(i) = msdSum;
end


% sum of SSD computed over couples
val = sum(res);



function [res grad] = computeMSDWithGrad(img1, img2, points, transfo, gradient)

% compute values in image 1
[values1 inside1] = img1.evaluate(points);

% compute values in image 2
[values2 inside2] = img2.evaluate(points);

% keep only valid values
isInside = inside1 & inside2;

if sum(isInside) < 100
    error('Too many points outside registration window');
end

% compute result
diff = values2(isInside) - values1(isInside);

% average over all points
np  = length(isInside);
res = sum(diff .^ 2) / np;

% extract number of parameters
nParams = length(transfo.getParameters());

% compute transformed coordinates
points2 = transfo.transformPoint(points);

% evaluate gradient, and re-compute points within image frame, as gradient
% evaluator can have different behaviour at image borders.
[gradVals gradInside] = gradient.evaluate(points2);

% convert to indices
inds    = find(gradInside);
nbInds  = length(inds);
g = zeros(nbInds, nParams);

for i=1:nbInds
    iInd = inds(i);
    
    % calcule jacobien pour points valides (repere image fixe)
    p0 = points(iInd, :);
    jac = getParametricJacobian(transfo, p0);
    
    % % local contribution to metric gradient
    g(iInd, :) = gradVals(iInd, :)*jac;
end

% re-compute differences, by considering position that can be used for
% computing gradient
diff = values2(gradInside) - values1(gradInside);

% compute gradient vectors weighted by local differences
gd = g(inds,:).*diff(:, ones(1, nParams));

% remove some NAN values that could occur for an obscure reason
gd = gd(~isnan(gd(:,1)), :);

% mean of valid gradient vectors
grad = mean(gd, 1);

