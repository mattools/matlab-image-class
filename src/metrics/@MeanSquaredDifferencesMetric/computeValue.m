function [res isInside] = computeValue(this)
%COMPUTEVALUE Compute metric value
%
% [VALUE INSIDE] = METRIC.computeValue();
% Computes and return the value. Returns also a flag that indicates
% which test points belong to both images.
%

% compute values in image 1
[values1 inside1] = this.img1.evaluate(this.points);

% compute values in image 2
[values2 inside2] = this.img2.evaluate(this.points);

% % keep only valid values
isInside = inside1 & inside2;

% % compute result
% diff = (values2(isInside) - values1(isInside)).^2;

values1(~inside1) = 0;
values2(~inside2) = 0;

diff = (values2 - values1).^2;

% average over all points
np = length(isInside);
res = sum(diff)/np;
