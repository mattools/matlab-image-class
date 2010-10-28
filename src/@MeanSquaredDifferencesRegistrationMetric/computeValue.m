function [res isInside] = computeValue(this)
%COMPUTEVALUE Compute metric value
%
% [VALUE INSIDE] = METRIC.computeValue();
% Computes and return the value. Returns also a flag that indicates
% which test points belong to both images.
%

% compute values in image 1
[values1 inside1] = this.fixedImage.evaluate(this.points);

% compute values in image 2
[values2 inside2] = this.transformedImage.evaluate(this.points);

% keep only valid values
isInside = inside1 & inside2;

% compute result
diff = (values2(isInside) - values1(isInside)).^2;
res = mean(diff);
