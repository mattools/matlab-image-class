classdef MeanSquaresImageToImageMetric < ImageToImageMetric
%MEANSQUARESIMAGETOIMAGEMETRIC Compute mean square of differences metric
%
%   output = MeanSquaresImageToImageMetric(input)
%
%   Example
%   MeanSquaresImageToImageMetric
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Constructor
methods
    function this = MeanSquaresImageToImageMetric(varargin)
        % calls the parent constructor
        this = this@ImageToImageMetric(varargin{:});
        
    end % constructor
    
end % methods

%% Implemented methods
methods
    function [res isInside] = computeValue(this)
        % compute metric value.
        
        % compute values in image 1
        [values1 inside1] = this.img1.evaluate(this.points);
        
        % compute values in image 2
        [values2 inside2] = this.img2.evaluate(this.points);
        
        % keep only valid values
        isInside = inside1 & inside2;
        
        % compute result
        diff = (values1(isInside) - values2(isInside)).^2;
        res = mean(diff);
    end
    
    function [res grad isInside] = computeValueAndGradient(this, transfo, gx, gy)
        % compute metric value and gradient
        % [RES DERIV] = this.computeValue(MODEL);
        %
        % Example:
        % ssdMetric = SSDMetricCalculator(img1, img2, dx1, dy1);
        % model = Translation2DModel([1.2 2.3]);
        % res = ssdMetric.computeValue(model);
        %
        
        % compute values in image 1
        [values1 inside1] = this.img1.evaluate(this.points);
        
        % compute values in image 2
        [values2 inside2] = this.img2.evaluate(this.points);
                
        % keep only valid values
        isInside = inside1 & inside2;
        
        % compute result
        diff = (values1(isInside) - values2(isInside)).^2;
        res = mean(diff);

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
        
        % moyenne des vecteurs gradient valides
        grad = mean(gd, 1);

    end
    
end % methods

end % classdef
