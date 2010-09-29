function value = evaluateSumOfSSDAndMotionDeviationValue(params, tims, points, weights)
%EVALUATESUMOFSSDVALUE Regularized multi SSD Metric
%
%   SSSD = evaluateSumOfSSDAndMotionDeviationValue(PARAMS, TIM1, TIM2, POINTS, WEIGHTS)
%   PARAMS: concatenated vector of parameters
%   TIMS: set of images (eventually interpolated and/or transformed)
%   POINTS: the set of test points used for evaluating SSD
%   WEIGHTS weights associated to (1) the metric and (2) the transform
%       regularisation
%
%   Example
%   evaluateSumOfSSDValue
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-09-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Init

% total length of parameter vector
n = length(params);

nImages = length(tims);

nParams = n/nImages;


%% Update transform parameters

% update each transform
for i=1:nImages
    localParams = params((i-1)*nParams+1:(i-1)*nParams+nParams);
    tims{i}.transform.setParameters(localParams);
end


%% Compute metric value 

metricValue = computeSumOfSSDValue(tims, points);


%% Compute transform regularisation

regulValue = 0;
for i = 1:nImages
    regulImage = computeMotionDeviation(tims{i}.transform);
    regulValue = regulValue + regulImage^2;
end


%% compute weighjted sum of metric and regularisation

value = metricValue*weights(1) + regulValue*weights(2);

