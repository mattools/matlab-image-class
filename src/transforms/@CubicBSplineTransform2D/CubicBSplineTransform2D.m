classdef CubicBSplineTransform2D < ParametricTransform
%CUBICBSPLINETRANSFORM2D  One-line description here, please.
%
%   output = CubicBSplineTransform2D(input)
%
%   Example
%   CubicBSplineTransform2D
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-02-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

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
    function this = CubicBSplineTransform2D(varargin)
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
        % Compute corodinates of transformed point
        
        % compute centered coords.
        x = point(:, 1);
        y = point(:, 2);
        
        % compute position wrt to the grid vertices
        xg = (x - this.gridOrigin(1)) / this.gridSpacing(1) + 1;
        yg = (y - this.gridOrigin(2)) / this.gridSpacing(2) + 1;
        
        % compute indices of points located within interpolation area
        isInsideX   = xg >= 2 & xg < this.gridSize(1)-1;
        isInsideY   = yg >= 2 & yg < this.gridSize(2)-1;
        isInside    = isInsideX & isInsideY;
        
        % select valid points
        xg = xg(isInside);
        yg = yg(isInside);
        
        % compute indices in linear indexing
        dimXY = prod(this.gridSize);

        % coordinates within the unit tile
        xu = xg - floor(xg);
        yu = yg - floor(yg);
       
       % initialize zeros translation vector
        dx = zeros(length(xg), 1);
        dy = zeros(length(xg), 1);
        
        baseFuns = {...
            @BSplines.beta3_0, ...
            @BSplines.beta3_1, ...
            @BSplines.beta3_2, ...
            @BSplines.beta3_3};
        
        % iteration on each tile of the grid
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
                
                fun_i = baseFuns{i+2};
                fun_j = baseFuns{j+2};
                
                % update total translation component
                b = fun_i(xu) .* fun_j(yu);
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
        
        
        %% Constants
        
        % bspline basis functions and derivative functions
        baseFuns = {...
            @BSplines.beta3_0, ...
            @BSplines.beta3_1, ...
            @BSplines.beta3_2, ...
            @BSplines.beta3_3};
        
        derivFuns = {...
            @BSplines.beta3_0d, ...
            @BSplines.beta3_1d, ...
            @BSplines.beta3_2d, ...
            @BSplines.beta3_3d};

        
        %% Initializations
       
        % extract coordinates
        x = point(:, 1);
        y = point(:, 2);
        
        % compute position wrt to the grid vertices
        deltaX = this.gridSpacing(1);
        deltaY = this.gridSpacing(2);
        xg = (x - this.gridOrigin(1)) / deltaX + 1;
        yg = (y - this.gridOrigin(2)) / deltaY + 1;
        
        % compute indices of values within interpolation area
        isInsideX = xg >= 2 & xg < this.gridSize(1)-1;
        isInsideY = yg >= 2 & yg < this.gridSize(2)-1;
        isInside = isInsideX & isInsideY;
        inds = isInside;

        % keep only valid positions
        xg = xg(isInside);
        yg = yg(isInside);
        
        % initialize zeros translation vector
        nValid = length(xg);

        % coordinates within the unit tile
        xu = reshape(xg - floor(xg), [1 1 nValid]);
        yu = reshape(yg - floor(yg), [1 1 nValid]);       

        % compute indices in linear indexing
        dimXY = prod(this.gridSize);
        
        % allocate memory for storing result, and initialize to identity
        % matrix
        jac = zeros(2, 2, size(point, 1));
        jac(1, 1, :) = 1;
        jac(2, 2, :) = 1;
        
        
        %% Iteration on neighbor tiles 
        
        for i=-1:2
            % x-coordinate of neighbor vertex
            xv  = floor(xg) + i;
            
            % compute x-coefficients of bezier function and derivative
            bx  = baseFuns{i+2}(xu);
            bxd = derivFuns{i+2}(xu);
            
            for j=-1:2
                % y-coordinate of neighbor vertex
                yv = floor(yg) + j;
                
                % linear index of translation components
                indX = sub2ind([this.gridSize], xv, yv);
                indY = sub2ind([this.gridSize], xv, yv) + dimXY;
                
                % translation vector of the current vertex
                dxv = reshape(this.params(indX), [1 1 length(inds)]);
                dyv = reshape(this.params(indY), [1 1 length(inds)]);
                
                % compute y-coefficients of bezier function and derivative
                by  = baseFuns{j+2}(yu);
                byd = derivFuns{j+2}(yu);

                % update jacobian matrix elements
                jac(1, 1, inds) = jac(1, 1, inds) + bxd .* by  .* dxv / deltaX;
                jac(1, 2, inds) = jac(1, 2, inds) + bx  .* byd .* dxv / deltaY;
                jac(2, 1, inds) = jac(2, 1, inds) + bxd .* by  .* dyv / deltaX;
                jac(2, 2, inds) = jac(2, 2, inds) + bx  .* byd .* dyv / deltaY;
            end
        end

    end
    
    function jac = getParametricJacobian(this, x, varargin)
        % Compute parametric jacobian for a specific position
        % The result is a ND-by-NP array, where ND is the number of
        % dimension, and NP is the number of parameters.
        
        % extract coordinate of input point
        if isempty(varargin)
            y = x(:,2);
            x = x(:,1);
        else
            y = varargin{1};
        end
        
        % compute position wrt to the grid vertices
        deltaX = this.gridSpacing(1);
        deltaY = this.gridSpacing(2);
        xg = (x - this.gridOrigin(1)) / deltaX + 1;
        yg = (y - this.gridOrigin(2)) / deltaY + 1;
        
        % compute indices of values within interpolation area
        isInsideX = xg >= 2 & xg < this.gridSize(1)-1;
        isInsideY = yg >= 2 & yg < this.gridSize(2)-1;
        isInside = isInsideX & isInsideY;
        inds = find(isInside);
        
        % keep only valid positions
        xg = xg(isInside);
        yg = yg(isInside);
        
        % initialize zeros translation vector
        nValid = length(xg);

        % pre-allocate result array
        nd = length(this.gridSize);
        np = length(this.params);
        jac = zeros(nd, np, length(x));

        % if point is outside, return zeros matrix
        if ~isInside
            return;
        end
        
        % coordinates within the unit tile
        xu = reshape(xg - floor(xg), [1 1 nValid]);
        yu = reshape(yg - floor(yg), [1 1 nValid]);       
        
        dimXY = prod(this.gridSize);
        
        baseFuns = {...
            @BSplines.beta3_0, ...
            @BSplines.beta3_1, ...
            @BSplines.beta3_2, ...
            @BSplines.beta3_3};
        
        % iteration on each tile of the grid
        for i=-1:2
            xv = floor(xg) + i;
            fun_i = baseFuns{i+2};
            
            for j=-1:2
                % coordinates of neighbor vertex
                yv = floor(yg) + j;
                
                % linear index of translation components
                indX = sub2ind([this.gridSize], xv, yv);
                indY = sub2ind([this.gridSize], xv, yv) + dimXY;
                
                fun_j = baseFuns{j+2};
                
                % update total translation component
                b = fun_i(xu) .* fun_j(yu);
                
                % update jacobian matrix
                iValid = ones(nValid, 1);
                jac(sub2ind(size(jac), 1*iValid, indX, inds)) = b;
                jac(sub2ind(size(jac), 2*iValid, indY, inds)) = b;
            end
        end
        
    end
    
   
end % general methods

end % classdef
