classdef BSplineTransform2D < ParametricTransform
%BSPLINETRANSFORM2D  One-line description here, please.
%
%   output = BSplineTransform2D(input)
%
%   Example
%   BSplineTransform2D
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Properties
properties
    gridSize;
    gridSpacing;
    gridOrigin;
end 

%% Constructor
methods
    function this = BSplineTransform2D(varargin)
        % Ajouter le code du constructeur ici
        if nargin==1
            var = varargin{1};
            if isscalar(var)
                nd = var;
                this.gridSize       = ones(1, nd);
                this.gridSpacing    = ones(1, nd);
                this.gridOrigin     = zeros(1, nd);
                initializeParameters();
            end
            
        elseif nargin==3
            this.gridSize       = varargin{1};
            this.gridSpacing    = varargin{2};
            this.gridOrigin     = varargin{3};
            initializeParameters();
        end

        function initializeParameters()
            dim = this.gridSize();
            np  = prod(dim)*length(dim);
            this.params = zeros(1, np);
        end
    end % constructor 

end % construction function

%% General methods
methods

    function [point2 isInside] = transformPoint(this, point)
        % compute centered coords.
        x = point(:, 1);
        y = point(:, 2);
        
        % compute position wrt to the grid vertices
        xg = (x - this.gridOrigin(1)) / this.gridSpacing(1) + 1;
        yg = (y - this.gridOrigin(2)) / this.gridSpacing(2) + 1;
        
        % compute indices of values within interpolation area
        isInsideX = xg>=2 & xg<this.gridSize(1)-1;
        isInsideY = yg>=2 & yg<this.gridSize(2)-1;
        isInside = isInsideX & isInsideY;
        xg = xg(isInside);
        yg = yg(isInside);
        
%         % compute indices in linear indexing
%         dimX = this.gridSize(1);
        dimXY = prod(this.gridSize);

       % initialize zeros translation vector
        dx = zeros(length(xg), 1);
        dy = zeros(length(xg), 1);
        
        for i=-1:2
            for j=-1:2
                % coordinates of neighbor vertex
                xv = floor(xg) + i;
                yv = floor(yg) + j;
                
                % linear index of translation components
                indX = sub2ind([this.gridSize], xv, yv);
                indY = sub2ind([this.gridSize], xv, yv) + dimXY;
%                 indX = (xv-1) + dimX*(yv-1) + 1;
%                 indY = (xv-1) + dimX*(yv-1) + 1 + dimXY;
                
                % translation vector of the current vertex
                dxv = this.params(indX)';
                dyv = this.params(indY)';
                
                % update total translation component
                b = beta3(xg - xv) .* beta3(yg - yv);
                dx = dx + b.*dxv; 
                dy = dy + b.*dyv; 
            end
        end
        
        % update coordinates of transformed point
        point2 = point;
        point2(isInside, 1) = point(isInside, 1) + dx;
        point2(isInside, 2) = point(isInside, 2) + dy;
        
        function b = beta3(x)
            %BETA3  One-line description here, please.
            b = zeros(size(x));
            ax = abs(x);
            
            ind = ax<=1;
            b(ind) = -ax(ind).^2 + ax(ind).^3/2 + 2/3;
            
            ind = ax<=2 & ax>1;
            b(ind) = (2 - ax(ind)).^3 / 6;
        end
    end
    
    function ux = getUx(this, x, y)
        ind = sub2ind([this.gridSize 2], x, y, 1);
        ux = this.params(ind);
    end
    
    function setUx(this, x, y, ux)
        ind = sub2ind([this.gridSize 2], x, y, 1);
        this.params(ind) = ux;
    end
    
    function uy = getUy(this, x, y)
        ind = sub2ind([this.gridSize 2], x, y, 2);
        uy = this.params(ind);
    end
    
    function setUy(this, x, y, uy)
        ind = sub2ind([this.gridSize 2], x, y, 2);
        this.params(ind) = uy;
    end
    
    function drawGrid(this)
        % Draw the transformed grid
        lx = (0:this.gridSize(1) - 1) * this.gridSpacing(1) + this.gridOrigin(1);
        ly = (0:this.gridSize(2) - 1) * this.gridSpacing(2) + this.gridOrigin(2);
        
        % create base mesh
        [x y] = meshgrid(lx, ly);
        
        % add grid shifts
        x = x' + reshape(this.params(1:end/2), this.gridSize);
        y = y' + reshape(this.params(end/2+1:end), this.gridSize);
        
        inds = reshape((1:numel(x)), this.gridSize);
        
        % create vertex array
        v = [x(:) y(:)];
        
        % edges in direction x
        ne1 = (this.gridSize(2) - 1) * this.gridSize(1);
        e1 = [reshape(inds(:, 1:end-1), [ne1 1]) reshape(inds(:, 2:end), [ne1 1])];
        % edges in direction y
        ne2 = this.gridSize(2) * (this.gridSize(1) - 1);
        e2 = [reshape(inds(1:end-1, :), [ne2 1]) reshape(inds(2:end, :), [ne2 1])];
        
        % create edge array
        e = cat(1, e1, e2);

        drawGraph(v, e);
    end
    
    function transformVector(this, varargin) %#ok<MANU>
        error('oolip:UnimplementedMethod', ...
            'Method "%s" is not implemented for class "%s"', ...
            'transformVector', mfilename);
    end
    
    function getJacobian(this, point) %#ok<INUSD,MANU>
        error('oolip:UnimplementedMethod', ...
            'Method "%s" is not implemented for class "%s"', ...
            'getJacobian', mfilename);
    end
    
    function getParametricJacobian(this, x, varargin) %#ok<INUSD,MANU>
        error('oolip:UnimplementedMethod', ...
            'Method "%s" is not implemented for class "%s"', ...
            'getParametricJacobian', mfilename);
    end
    
   
end % general methods

end % classdef
