function [res grad isInside] = computeValueAndGradient(this, varargin)
% Compute metric value and gradient
%
%   [RES DERIV] = this.computeValueAndGradient();
%   This syntax requires that both fields 'transform' and 'gradientImage'
%   have been initialized.
%
%   [RES DERIV] = this.computeValueAndGradient(TRANSFO, GRADX, GRADY);
%   [RES DERIV] = this.computeValueAndGradient(TRANSFO, GRADX, GRADY, GRADZ);
%   This (deprecated) syntax passes transform model and gradient components
%   as input arguments.
%
% Example:
% transfo = Translation2DModel([1.2 2.3]);
% ssdMetric = SumOfSquaredDifferencesMetric(img1, img2, transfo);
% res = ssdMetric.computeValueAndGradient(model);
%


nd = getDimension(this.img1);

useClassFields = ~isempty(this.transform) && ~isempty(this.gradientImage);

% The first part of the file consists in analyzing input, and to call the
% most appropriate subfunction
if useClassFields
    
    % If the gradient image is an image function, it is assumed to be a 
    % gradient interpolator or a gradient evaluator
    if isa(this.gradientImage, 'ImageFunction')
        [res grad isInside] = ...
            computeValueAndGradientFromGradientFunction(this);
        return;
    end
    
    % if gradient image is a standard image, use specific methods that
    % perform dimension-specific nearest-neighbor interpolation
    if nd==2
        [res grad isInside] = computeValueAndGradientLocal2d(this);
    elseif nd==3
        [res grad isInside] = computeValueAndGradientLocal3d(this);
    else
        [res grad isInside] = computeValueAndGradientLocal(this);
    end
    
else
    % deprecation warning
    warning('oolip:deprecated', ...
        'Deprecated syntax. Please initialize metric fields instead');
  
    if length(varargin)<nd
        error('Requires as many gradient components as the number of dimensions');
    end
    
    % assumes transfor and gradient components are given as arguments
    if nd == 2
        [res grad isInside] = computeValueAndGradient2d(this, varargin{:});
    else
        [res grad isInside] = computeValueAndGradient3d(this, varargin{:});
    end
end

% end of main function


function [res grad isInside] = computeValueAndGradientLocal(this)

% compute values in image 1
[values1 inside1] = evaluate(this.img1, this.points);

% compute values in image 2
[values2 inside2] = evaluate(this.img2, this.points);

% keep only valid values
isInside = inside1 & inside2;

% compute result
diff = values2(isInside) - values1(isInside);

% average over all points
np = length(isInside);
res = sum(diff.^2)/np;

%fprintf('Initial SSD: %f\n', res);

% convert to indices
inds    = find(isInside);
nInds   = length(inds);

transfo = this.transform;
nParams = length(getParameterLength(transfo));
gd = zeros(nInds, nParams);

% convert from physical coordinates to index coordinates
% (assumes spacing is 1 and origin is 0)
points2 = transformPoint(transfo, this.points);
indices = round(points2(inds, :))+1;

for i=1:length(inds)
    iInd = inds(i);
    
    % compute jacobian for valid points (in fixed image reference system)
    jac = getParametricJacobian(transfo, this.points(iInd, :));
    
    % local gradient in moving image
    subs = num2cell(indices(i, :));
    grad = getPixel(this.gradientImage, subs{:});
    
    % local contribution to metric gradient
    gd(i, :) = grad*jac;
end

% compute gradient vectors weighted by local differences
gd = gd .* diff(:, ones(1, nParams));

% mean of valid gradient vectors
grad = mean(gd, 1);





function [res grad isInside] = computeValueAndGradientLocal2d(this)
%Assumes gradient image is 2D

% compute values in image 1
[values1 inside1] = evaluate(this.img1, this.points);

% compute values in image 2
[values2 inside2] = evaluate(this.img2, this.points);

% keep only valid values
isInside = inside1 & inside2;

% compute result
diff = values2(isInside) - values1(isInside);

% average over all points
np  = length(isInside);
res = sum(diff .^ 2) / np;

%fprintf('Initial SSD: %f\n', res);

% convert to indices
inds    = find(isInside);
nInds   = length(inds);

transfo = this.transform;
nParams = getParameterLength(transfo);
gd      = zeros(nInds, nParams);

% compute transformed coordinates
points2 = transformPoint(transfo, this.points);

% convert from physical coordinates to index coordinates
% (assumes spacing is 1 and origin is 0)
indices = round(points2(inds, :)) + 1;

gradImg = this.gradientImage.data;

for i = 1:nInds
    iInd = inds(i);
    
    % compute jacobian for valid points (in fixed image reference system)
    p0 = this.points(iInd, :);
    jac = getParametricJacobian(transfo, p0);
    
    % local gradient in moving image
    ind1 = indices(i,1);
    ind2 = indices(i,2);
    
    grad = [gradImg(ind1, ind2, 1) gradImg(ind1, ind2, 2)];
    
    % local contribution to metric gradient
    gd(i, :) = grad*jac;
end

% compute gradient vectors weighted by local differences
gd = gd .* diff(:, ones(1, nParams));

% mean of valid gradient vectors
grad = mean(gd, 1);



function [res grad isInside] = computeValueAndGradientLocal3d(this)
%Assumes gradient image is 3D


% compute values in image 1
[values1 inside1] = evaluate(this.img1, this.points);

% compute values in image 2
[values2 inside2] = evaluate(this.img2, this.points);

% keep only valid values
isInside = inside1 & inside2;

if sum(isInside) < 100
    error('Too many points outside registration window');
end

% compute result
diff = values2(isInside) - values1(isInside);

% average over all points
np  = length(isInside);
res = sum(diff.^2)/np;

%fprintf('Initial SSD: %f\n', res);

% convert to indices
inds    = find(isInside);
nInds   = length(inds);

transfo = this.transform;
nParams = getParameterLength(transfo);
gd = zeros(nInds, nParams);

% compute transformed coordinates
points2 = transformPoint(transfo, this.points);

% convert from physical coordinates to index coordinates
% (assumes spacing is 1 and origin is 0)
indices = round(points2(inds, :)) + 1;

gradImg = this.gradientImage.data;

for i = 1:length(inds)
    iInd = inds(i);
    
    % calcule jacobien pour points valides (repere image fixe)
    p0 = this.points(iInd, :);
    jac = getParametricJacobian(transfo, p0);
    
    % local gradient in moving image
    ind1 = indices(i,1);
    ind2 = indices(i,2);
    ind3 = indices(i,3);

    grad = [...
        gradImg(ind1, ind2, ind3, 1) ...
        gradImg(ind1, ind2, ind3, 2) ...
        gradImg(ind1, ind2, ind3, 3) ];

    % local contribution to metric gradient
    tmp = grad * jac;
    gd(i, :) = tmp;
end

% compute gradient vectors weighted by local differences
gd = gd .* diff(:, ones(1, nParams));

% mean of valid gradient vectors
grad = mean(gd, 1);


function [res grad isInside] = computeValueAndGradientFromGradientFunction(this)
% Assumes gradient image is an ImageFunction that evaluates or interpolates
% gradient of another image
% the interpolated/evaluated gradient is not transformed, this operation is
% left to this function

% compute values in image 1
[values1 inside1] = evaluate(this.img1, this.points);

% compute values in image 2
[values2 inside2] = evaluate(this.img2, this.points);

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

%fprintf('Initial SSD: %f\n', res);


transfo = this.transform;
nParams = getParameterLength(transfo);

% compute transformed coordinates
points2 = transformPoint(transfo, this.points);

% evaluate gradient, and re-compute points within image frame, as gradient
% evaluator can have different behaviour at image borders.
[gradVals gradInside] = evaluate(this.gradientImage, points2);

% convert to indices
inds    = find(gradInside);
nInds   = length(inds);
gd      = zeros(nInds, nParams);

for i = 1:nInds
    iInd = inds(i);
    
    % compute jacobian for valid points (in fixed image reference system)
    p0  = this.points(iInd, :);
    jac = getParametricJacobian(transfo, p0);
    
    % % local contribution to metric gradient
    gd(i, :) = gradVals(iInd, :)*jac;
end

% re-compute differences, by considering position that can be used for
% computing gradient
diff = values2(gradInside) - values1(gradInside);

% compute gradient vectors weighted by local differences
gd = gd .* diff(:, ones(1, nParams));

% remove some NAN values that could occur for an obscure reason
gd = gd(~isnan(gd(:,1)), :);

% mean of valid gradient vectors
grad = mean(gd, 1);



function [res grad isInside] = computeValueAndGradient2d(this, transfo, gx, gy)
% Old function to compute metric and gradient of a 2D image using 2 args

% compute values in image 1
[values1 inside1] = evaluate(this.img1, this.points);

% compute values in image 2
[values2 inside2] = evaluate(this.img2, this.points);

% keep only valid values
isInside = inside1 & inside2;

% compute result
diff = values2(isInside) - values1(isInside);

% average over all points
np = length(isInside);
res = sum(diff .^ 2) / np;

%fprintf('Initial SSD: %f\n', res);


% convert to indices
inds    = find(isInside);
nInds   = length(inds);

%nPoints = size(points, 1);
nParams = getParameterLength(transfo);
gd = zeros(nInds, nParams);

% convert from physical coordinates to index coordinates
% (assumes spacing is 1 and origin is 0)
% also converts from (x,y) to (i,j)
points2 = transfo.transformPoint(this.points);
index = round(points2(inds, [2 1]))+1;

for i = 1:nInds
    % compute jacobian for valid points (in fixed image reference system)
    jac = getParametricJacobian(transfo, this.points(inds(i), :));
    
    % local gradient in moving image
    i1 = index(i, 1);
    i2 = index(i, 2);
    grad = [gx(i1, i2) gy(i1, i2)];
    
    % local contribution to metric gradient
    gd(i, :) = grad * jac;
end

% calcul du vecteur gradient pondere par difference locale
gd = gd .* diff(:, ones(1, nParams));

% somme des vecteurs gradient valides
grad = mean(gd, 1);


function [res grad isInside] = computeValueAndGradient3d(this, transfo, gx, gy, gz)
% Old function to compute metric and gradient of a 3D image using 3 args

% compute values in image 1
[values1 inside1] = evaluate(this.img1, this.points);

% compute values in image 2
[values2 inside2] = evaluate(this.img2, this.points);

% keep only valid values
isInside = inside1 & inside2;

% compute result
diff = values2(isInside) - values1(isInside);

% average over all points
np  = length(isInside);
res = sum(diff .^ 2) / np;


% convert to indices
inds    = find(isInside);
nInds   = length(inds);

nParams = getParameterLength(transfo);
gd      = zeros(nInds, nParams);

% convert from physical coordinates to index coordinates
% (assumes spacing is 1 and origin is 0)
% also converts from (x,y) to (i,j)
points2 = transformPoint(transfo, this.points);
index = round(points2(inds, [2 1 3]))+1;

for i = 1:nInds
    % compute jacobian for valid points (in fixed image reference system)
    jac = getParametricJacobian(transfo, this.points(inds(i),:));
    
    % local gradient in moving image
    i1 = index(i, 1);
    i2 = index(i, 2);
    i3 = index(i, 3);
    grad = [gx(i1,i2,i3) gy(i1,i2,i3) gz(i1,i2,i3)];
    
    % local contribution to metric gradient
    gd(i, :) = grad * jac;
end

% calcul du vecteur gradient pondere par difference locale
gd = gd .* diff(:, ones(1, nParams));

% somme des vecteurs gradient valides
grad = mean(gd, 1);
