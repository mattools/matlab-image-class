function res = minimizeImageToTransformedImageMetric(params, transfo, metric)
%Function handle to minimize a parameterized transform using a metric 
%
%   VALUE = minimizeImageToTransformedImageMetric(PARAMS, TRANSFO, METRIC)
%   PARAMS: parameters of the transform TRANSFO, as a row vector
%   TRANSFO: an instance of a ParametricTransform
%   METRIC: a ImageToImageMetric object, that was initialised with (1) an
%       itnerpolator on the first image, (2) an interpolator on the image
%       transformed by transfo TRANSO, and (3) a set of test points.
%
%   Example
%     img1 = uint8(discreteDisc(1:100, 1:100, [50 50 30])*255);
%     interp1 = LinearInterpolator2D(Image2D(img1));
%     img2 = uint8(discreteDisc(1:100, 1:100, [40 55 30])*255);
%     interp2 = LinearInterpolator2D(Image2D(img2));
%     [x y] = meshgrid(1:100, 1:100);
%     points = [x(:)-1 y(:)-1];
%     transfo = TranslationModel([0 0]);
%     tim = BackwardTransformedImage(interp2, transfo);
%     metric = MeanSquaresImageToImageMetric(interp1, tim, points);
%     p0 = [0 0];           % initial params
%     dirset= [1 0;0 1];    % direction set
%     fun = @(params) essaiMinimizer(params, transfo, metric);
%     [paramOptim value] = directionSetMinimizer(fun, p0, dirset, 1e-2)
% 
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
