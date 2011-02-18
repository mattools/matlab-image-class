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
    % Number of vertices of the grid in each direction
    gridSize;
    % Coordinates of the first vertex of the grid
    gridOrigin;
    % Spacing between the vertices
    gridSpacing;
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
        
        % compute indices in linear indexing
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

        % create vertex array
        v = getGridVertices(this);
        
        nv = size(v, 1);
        inds = reshape(1:nv, this.gridSize);
        
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
    
    function vertices = getGridVertices(this)
        % get coordinates of grid vertices
        
        % base coordinates of grid vertices
        lx = (0:this.gridSize(1) - 1) * this.gridSpacing(1) + this.gridOrigin(1);
        ly = (0:this.gridSize(2) - 1) * this.gridSpacing(2) + this.gridOrigin(2);
        
        % create base mesh
        [x y] = meshgrid(lx, ly);
        
        % add grid shifts
        x = x' + reshape(this.params(1:end/2), this.gridSize);
        y = y' + reshape(this.params(end/2+1:end), this.gridSize);
        
        % create vertex array
        vertices = [x(:) y(:)];
    end
    
    function transformVector(this, varargin) %#ok<MANU>
        error('oolip:UnimplementedMethod', ...
            'Method "%s" is not implemented for class "%s"', ...
            'transformVector', mfilename);
    end
    
    function jac = getJacobian(this, point)
        % Jacobian matrix of the given point
        %
        
        % extract coordinates
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
        
        % compute indices in linear indexing
        dimXY = prod(this.gridSize);

        % initialize zeros translation vector
        nValid = length(xg);
       
        dxx = ones(nValid, 1);
        dxy = zeros(nValid, 1);
        dyx = zeros(nValid, 1);
        dyy = ones(nValid, 1);
        
        for i=-1:2
            for j=-1:2
                % coordinates of neighbor vertex
                xv = floor(xg) + i;
                yv = floor(yg) + j;
                
                % linear index of translation components
                indX = sub2ind([this.gridSize], xv, yv);
                indY = sub2ind([this.gridSize], xv, yv) + dimXY;
                
                % translation vector of the current vertex
                dxv = this.params(indX)';
                dyv = this.params(indY)';
                
                % pre-compute derivative parts
                bx  = beta3(xg - xv);
                by  = beta3(yg - yv);
                bxd = beta3d(xg - xv);
                byd = beta3d(yg - yv);

                % update jacobian matrix elements
                dxx = dxx + bxd .* by   .* dxv;
                dxy = dxy + bx  .* byd  .* dxv;
                dyx = dyx + bxd .* by   .* dyv;
                dyy = dyy + bx  .* byd  .* dyv;
            end
        end

        % concatenate results into jacobian matrix
        jac = zeros(2, 2, size(point, 1));
        jac(1, 1, isInside) = dxx;
        jac(1, 2, isInside) = dxy;
        jac(2, 1, isInside) = dyx;
        jac(2, 2, isInside) = dyy;
    end
    
    function getParametricJacobian(this, x, varargin) %#ok<INUSD,MANU>
        error('oolip:UnimplementedMethod', ...
            'Method "%s" is not implemented for class "%s"', ...
            'getParametricJacobian', mfilename);
    end
    
   
end % general methods

end % classdef
