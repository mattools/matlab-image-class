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

if ~isempty(this.transform) && ~isempty(this.gradientImage)
    nd = this.img1.getDimension();
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
    
    % assumes transfor and gradient components are given as arguments
    nd = this.img1.getDimension();
    if nd == 2
        [res grad isInside] = computeValueAndGradient2d(this, varargin{:});
    else
        [res grad isInside] = computeValueAndGradient3d(this, varargin{:});
    end
end

% end of main function


function [res grad isInside] = computeValueAndGradientLocal(this)

% error checking
if isempty(this.transform)
    error('Gradient computation requires transform');
end
if isempty(this.gradientImage)
    error('Gradient computation requires a gradient image');
end

% compute values in image 1
[values1 inside1] = this.img1.evaluate(this.points);

% compute values in image 2
[values2 inside2] = this.img2.evaluate(this.points);

% keep only valid values
isInside = inside1 & inside2;

% compute result
diff = values2(isInside) - values1(isInside);

% average over all points
np = length(isInside);
res = sum(diff.^2)/np;

%fprintf('Initial SSD: %f\n', res);

% convert to indices
inds = find(isInside);
nbInds = length(inds);

transfo = this.transform;
nParams = length(transfo.getParameters());
g = zeros(nbInds, nParams);

% convert from physical coordinates to index coordinates
% (assumes spacing is 1 and origin is 0)
points2 = transfo.transformPoint(this.points);
indices = round(points2(inds, :))+1;

for i=1:length(inds)
    iInd = inds(i);
    
    % calcule jacobien pour points valides (repere image fixe)
    jac = transfo.getParametricJacobian(this.points(iInd, :));
    
    % local gradient in moving image
    subs = num2cell(indices(i, :));
    grad = this.gradientImage.getPixel(subs{:});
    
    % local contribution to metric gradient
    g(iInd,:) = grad*jac;
end

% compute gradient vectors weighted by local differences
gd = g(inds,:).*diff(:, ones(1, nParams));

% mean of valid gradient vectors
grad = mean(gd, 1);





function [res grad isInside] = computeValueAndGradientLocal2d(this)
%Assumes gradient image is 2D


% error checking
if isempty(this.transform)
    error('Gradient computation requires transform');
end
if isempty(this.gradientImage)
    error('Gradient computation requires a gradient image');
end

% compute values in image 1
[values1 inside1] = this.img1.evaluate(this.points);

% compute values in image 2
[values2 inside2] = this.img2.evaluate(this.points);

% keep only valid values
isInside = inside1 & inside2;

% compute result
diff = values2(isInside) - values1(isInside);

% average over all points
np = length(isInside);
res = sum(diff.^2)/np;

%fprintf('Initial SSD: %f\n', res);

% convert to indices
inds = find(isInside);
nbInds = length(inds);

transfo = this.transform;
nParams = length(transfo.getParameters());
g = zeros(nbInds, nParams);

% compute transformed coordinates
points2 = transfo.transformPoint(this.points);

% convert from physical coordinates to index coordinates
% (assumes spacing is 1 and origin is 0)
indices = round(points2(inds, :)) + 1;

gradImg = this.gradientImage.data;

for i=1:length(inds)
    iInd = inds(i);
    
    % calcule jacobien pour points valides (repere image fixe)
    p0 = this.points(iInd, :);
    jac = getParametricJacobian(transfo, p0);
    
    % local gradient in moving image
    ind1 = indices(i,1);
    ind2 = indices(i,2);

    grad = [gradImg(ind1, ind2, 1) gradImg(ind1, ind2, 2)];

    % local contribution to metric gradient
    g(iInd,:) = grad*jac;
end

% compute gradient vectors weighted by local differences
gd = g(inds,:).*diff(:, ones(1, nParams));

% mean of valid gradient vectors
grad = mean(gd, 1);



function [res grad isInside] = computeValueAndGradientLocal3d(this)
%Assumes gradient image is 3D


% error checking
if isempty(this.transform)
    error('Gradient computation requires transform');
end
if isempty(this.gradientImage)
    error('Gradient computation requires a gradient image');
end

% compute values in image 1
[values1 inside1] = this.img1.evaluate(this.points);

% compute values in image 2
[values2 inside2] = this.img2.evaluate(this.points);

% keep only valid values
isInside = inside1 & inside2;

% compute result
diff = values2(isInside) - values1(isInside);

% average over all points
np = length(isInside);
res = sum(diff.^2)/np;

%fprintf('Initial SSD: %f\n', res);

% convert to indices
inds = find(isInside);
nbInds = length(inds);

transfo = this.transform;
nParams = length(transfo.getParameters());
g = zeros(nbInds, nParams);

% compute transformed coordinates
points2 = transfo.transformPoint(this.points);

% convert from physical coordinates to index coordinates
% (assumes spacing is 1 and origin is 0)
indices = round(points2(inds, :)) + 1;

gradImg = this.gradientImage.data;

for i=1:length(inds)
    iInd = inds(i);
    
    % calcule jacobien pour points valides (repere image fixe)
    p0 = this.points(iInd, :);
    jac = getParametricJacobian(transfo, p0);
    
    % local gradient in moving image
    ind1 = indices(i,1);
    ind2 = indices(i,2);
    ind3 = indices(i,3);

    grad = [gradImg(ind1, ind2, ind3, 1) gradImg(ind1, ind2, ind3, 2) ...
        gradImg(ind1, ind2, ind3, 3)];

    % local contribution to metric gradient
    g(iInd,:) = grad*jac;
end

% compute gradient vectors weighted by local differences
gd = g(inds,:).*diff(:, ones(1, nParams));

% mean of valid gradient vectors
grad = mean(gd, 1);





function [res grad isInside] = computeValueAndGradient2d(this, transfo, gx, gy)

% compute values in image 1
[values1 inside1] = this.img1.evaluate(this.points);

% compute values in image 2
[values2 inside2] = this.img2.evaluate(this.points);

% keep only valid values
isInside = inside1 & inside2;

% compute result
diff = values2(isInside) - values1(isInside);

% average over all points
np = length(isInside);
res = sum(diff.^2)/np;

%fprintf('Initial SSD: %f\n', res);


%% Compute gradient direction

% convert to indices
inds = find(isInside);
nbInds = length(inds);

%nPoints = size(points, 1);
nParams = length(transfo.getParameters());
g = zeros(nbInds, nParams);

% convert from physical coordinates to index coordinates
% (assumes spacing is 1 and origin is 0)
% also converts from (x,y) to (i,j)
points2 = transfo.transformPoint(this.points);
index = round(points2(inds, [2 1]))+1;

for i=1:length(inds)
    % calcule jacobien pour points valides (repere image fixe)
    jac = transfo.getParametricJacobian(this.points(inds(i),:));
    
    % local gradient in moving image
    i1 = index(i, 1);
    i2 = index(i, 2);
    grad = [gx(i1,i2) gy(i1,i2)];
    
    % local contribution to metric gradient
    g(inds(i),:) = grad*jac;
end

% calcul du vecteur gradient pondere par difference locale
gd = g(inds,:).*diff(:, ones(1, nParams));

% somme des vecteurs gradient valides
grad = mean(gd, 1);


function [res grad isInside] = computeValueAndGradient3d(this, transfo, gx, gy, gz)

%% Compute metric value

% compute values in image 1
[values1 inside1] = this.img1.evaluate(this.points);

% compute values in image 2
[values2 inside2] = this.img2.evaluate(this.points);

% keep only valid values
isInside = inside1 & inside2;

% compute result
diff = values2(isInside)-values1(isInside);

% average over all points
np = length(isInside);
res = sum(diff.^2)/np;


%% Compute gradient direction

% convert to indices
inds = find(isInside);
nbInds = length(inds);

%nPoints = size(points, 1);
nParams = length(transfo.getParameters());
g = zeros(nbInds, nParams);

% convert from physical coordinates to index coordinates
% (assumes spacing is 1 and origin is 0)
% also converts from (x,y) to (i,j)
points2 = transfo.transformPoint(this.points);
index = round(points2(inds, [2 1 3]))+1;

for i=1:length(inds)
    % calcule jacobien pour points valides (repere image fixe)
    jac = transfo.getParametricJacobian(this.points(inds(i),:));
    
    % local gradient in moving image
    i1 = index(i, 1);
    i2 = index(i, 2);
    i3 = index(i, 3);
    grad = [gx(i1,i2,i3) gy(i1,i2,i3) gz(i1,i2,i3)];
    
    % local contribution to metric gradient
    g(inds(i),:) = grad*jac;
end

% calcul du vecteur gradient pondere par difference locale
gd = g(inds,:).*diff(:, ones(1, nParams));

% somme des vecteurs gradient valides
grad = mean(gd, 1);
