function [fval grad] = computeValueAndGradient(this)
%COMPUTEVALUEANDGRADIENT Compute metric value and gradient using current state
%
%   [FVAL GRAD] = this.computeValueAndGradient()
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


% extract number of images (whic is also the number of transforms)
nImages = length(this.images);

% number of parameter for each transform (assumes this is the same)
nParams = length(this.transforms{1}.params);
    
% initialize empty metric value
fval = 0;

% initialize empty gradient
grad = zeros(1, nImages*nParams);

% index of current params vactor within gloabl param vector
ind = 1;

% Main iteration over all images (image1)
% image1 is assumed to be the moving image
for i=1:nImages
    % extract data specific to current image
    image1 = this.transformedImages{i};
    transfo = this.transforms{i};
    gradient = this.transformedGradients{i};
    
    % initialize zero gradient vector for current transform
    grad_i = zeros(1, nParams);
    
    % second iteration over all other images
    % image2 is fixed image, and we look for average transform towards all
    % images
    for j=[1:i-1 i+1:nImages]
        % extract other image
        image2 = this.transformedImages{j};
        
        % compute metric value and gradient on current combination of
        % images, transforms and parameters
        [fij gij] = computeMeanSquaredDifferences(image2, image1, ...
            this.points, transfo, gradient);
        %TODO: could avoid a great number of computation, as gradient is
        %evaluated within j-loop but does not change...

        % compute sum of values for all images
        fval = fval + fij;
        grad_i = grad_i + gij;
    end
    
    % update global parameter vector
    grad(ind:ind+nParams-1) = grad_i;
    ind = ind + nParams;
end





function [fval grad] = computeMeanSquaredDifferences(img1, img2, points, ...
    transfo, gradient)
% Compute Value and gradient for a couple of images

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
diff = values2 - values1;

% Sum of squared differences normalized by number of test points
fval = mean(diff.^2);


nParams = transfo.getParameterLength();

% evaluate gradient, and re-compute points within image frame, as gradient
% evaluator can have different behaviour at image borders.
[gradVals gradInside] = gradient.evaluate(points);

% convert to indices
inds    = find(gradInside);
nbInds  = length(inds);
g = zeros(nbInds, nParams);

for i=1:nbInds
    iInd = inds(i);
    
    % compute spatial jacobien for current point (in physical coords)
    p0 = points(iInd, :);
    jac = getParametricJacobian(transfo, p0);
    
    % local contribution to metric gradient
    g(iInd, :) = gradVals(iInd, :)*jac;
end

% re-compute differences, by considering position that can be used for
% computing gradient
diff = values2(gradInside) - values1(gradInside);

% compute gradient vectors weighted by local differences
gd = g(inds,:).*diff(:, ones(1, nParams));

% mean of valid gradient vectors
grad = mean(gd, 1);


