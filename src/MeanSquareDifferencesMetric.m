classdef MeanSquareDifferencesMetric < handle
%MEANSQUAREDIFFERENCESMETRIC SSD metric between 2 images
%   output = MeanSquareDifferencesMetric(input)
%
%   TODO: defined in 2D only
%
%   Example
%   MeanSquareDifferencesMetric
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-03-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Declaration of class properties
properties
    % the fixed image
    img1;
    % the moving image
    img2;
    % gradient of image 1 in x direction
    gx1;
    % gradient of image 1 in y direction
    gy1;
end

%% Constructors
methods
    function this = MeanSquareDifferencesMetric(img1, img2, gx1, gy1)
        if isa(img1, 'ImageFunction')
            this.img1 = img1;
        elseif isa(img1, 'Image')
            this.img1 = LinearInterpolator2D(img1);
        else
            error('First argument must be an image function');
        end
        
        if isa(img2, 'ImageFunction')
            this.img2 = img2;
        elseif isa(img2, 'Image')
            this.img2 = LinearInterpolator2D(img2);
        else
            error('Second argument must be an image function');
        end
        
        this.gx1 = gx1;
        this.gy1 = gy1;
        
    end % constructor declaration
end

%% Standard methods
methods
    function res = computeValue(this, points)
        % compute metric value.

        % compute values in image 1
        [values1 inside1] = this.img1.evaluate(points);
        
        % compute values in image 2
        [values2 inside2] = this.img2.evaluate(points);
        
        % keep only valid values
        inds = inside1 & inside2;
        
        % compute result
        diff = (values1(inds)-values2(inds)).^2;
        res = mean(diff);
    end
    
%     function res = computeValueOld(this, model)
%         % compute metric value.
%         % [RES DERIV] = this.computeValue(MODEL);
%         %
%         % Example:
%         % ssdMetric = SSDMetricCalculator(img1, img2, dx1, dy1);
%         % model = model = Translation2DModel([1.2 2.3]);
%         % res = ssdMetric.computeValue(model);
%         %
%          
%         % generate points in extent of fixed image
%         n = 2000;
%         box = this.img1.getPhysicalExtent();
%         points = randPointInBox(n, box);
%          
%         % compute values in image 1
%         [values1 inside1] = this.interp1.evaluate(points);
%         
%         % compute values in image 2
%         points2 = model.transformPoint(points);
%         [values2 inside2] = this.interp2.evaluate(points2);
%         
%         % keep only valid values
%         inds = inside1 & inside2;
%         nbValid = sum(inds);
%         
%         % compute result
%         diff = (values1-values2).^2;
%         res = sum(diff(inds))/nbValid;
%     end
%     
    function [res deriv] = computeValueAndGradient(this, points, model)
        % compute metric value and gradient
        % [RES DERIV] = this.computeValue(MODEL);
        %
        % Example:
        % ssdMetric = SSDMetricCalculator(img1, img2, dx1, dy1);
        % model = Translation2DModel([1.2 2.3]);
        % res = ssdMetric.computeValue(model);
        %
        
        % compute values in image 1
        [values1 inside1] = this.interp1.evaluate(points);
        
        % compute values in image 2
        [values2 inside2] = this.interp2.evaluate(points2);
        
        % keep only valid values
        inds = inside1 & inside2;
        
        % compute result
        diff = (values1(inds)-values2(inds)).^2;
        res = mean(diff);

        %fprintf('Initial SSD: %f\n', res);
        
        
        %% Compute gradient direction
        
        nParams = length(model.getParameters());
        g = zeros(nPoints, nParams);
        
        % conversion en coordonnees image
        this.gx1
        
        [index gValid] = this.img2.pointToIndex(points2);
        
        indValid = find(gValid);
        for i=1:length(indValid)
            ind = indValid(i);
            
            % calcule jacobien pour points valides (repere image fixe)
            jac = model.getParametricJacobian(points(ind,:));
          
            % local gradient in moving image
            i1 = index(ind, 2)+1;
            i2 = index(ind, 1)+1;
            grad = [this.dx(i1,i2) this.dy(i1,i2)];
            
            g(ind,:) = grad*jac;
        end
        
        % calcul du vecteur gradient pondere par difference locale
        gd = g.*diff(:, ones(1, nParams));
        
        % moyenne des vecteurs gradient valides
        deriv = mean(gd(inds, :), 1);
    end
    
end % public methods

end % classdef