function [res grad isInside] = computeValueAndGradient(this, transfo, gx, gy, gz)
% Compute metric value and gradient
%
% [RES DERIV] = this.computeValueAndGradient(MODEL, GRADX, GRADY);
%
% Example:
% transfo = Translation2DModel([1.2 2.3]);
% ssdMetric = SumOfSquaredDifferencesMetric(img1, img2, transfo);
% res = ssdMetric.computeValueAndGradient(model);
%

nd = this.img1.getDimension();

if nd == 2
    [res grad isInside] = computeValueAndGradient2d(this, transfo, gx, gy);
else
    [res grad isInside] = computeValueAndGradient3d(this, transfo, gx, gy, gz);
end


    function [res grad isInside] = computeValueAndGradient2d(this, transfo, gx, gy)
        
        % compute values in image 1
        [values1 inside1] = this.img1.evaluate(this.points);
        
        % compute values in image 2
        [values2 inside2] = this.img2.evaluate(this.points);
        
        % keep only valid values
        isInside = inside1 & inside2;
        
        % compute result
        diff = values2(isInside) - values1(isInside);
        res = sum(diff.^2);
        
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
        grad = sum(gd, 1);
        
    end

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
        res = sum(diff.^2);
        
        
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
        
        % moyenne des vecteurs gradient valides
        grad = sum(gd, 1);
        
    end

end