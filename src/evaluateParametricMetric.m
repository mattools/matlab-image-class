function res = evaluateParametricMetric(params, transfo, metric)
%evaluateParametricMetric Function handle for minimisation
%
%   VAL = evaluateParametricMetric(PARAMS, TRANSFO, METRIC)
%   Update the parametric transform TRANSFO with the given parameters, then
%   computes the metric.
%   
%   Inputs:
%   PARAMS a row vector as given as input of optimization functions
%   TRANSFO a parametric transform that accepts the same numbner of
%       parameters than the length of PARAMS
%   METRIC an instance of the class ImageToImageMetric, initialized with
%       two image functions, one image functions being the result of a
%       transformation by TRANSFO.
%   
%   Output:
%   VAL is the value of the metric computed for the given parameter.
%
%
%   Example
%     % create base images and associated interpolators
%     data1 = uint8(discreteDisc(1:100, 1:100, [50 50 30])*255);
%     interp1 = LinearInterpolator2D(Image2D.create(data1));
%     data2 = uint8(discreteDisc(1:100, 1:100, [40 55 30])*255);
%     interp2 = LinearInterpolator2D(Image2D.create(data2));
%     % create test points
%     [x y] = meshgrid(1:100, 1:100);
%     points = [x(:)-1 y(:)-1];
%     % initialize transformation model
%     transfo = TranslationModel([0 0]);
%     % transformed image
%     tim = BackwardTransformedImage(interp2, transfo);
%     % initialize a matric
%     metric = MeanSquaresImageToImageMetric(interp1, tim, points);
%     % The function to evaluate can be called by "val = fun(params);"
%     fun = @(params) evaluateParametricMetric(params, transfo, metric);
%     fun([0 0])
%     ans = 
%         8.8306e+003
%     fun([-10 5])
%     ans = 
%         54.4077
%   
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


transfo.setParameters(params);

res = metric.computeValue();
