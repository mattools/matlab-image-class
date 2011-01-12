classdef BSplineTransform3D < ParametricTransform
%BSplineTransform3D  One-line description here, please.
%
%   output = BSplineTransform3D(input)
%
%   Example
%   BSplineTransform3D
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
    function this = BSplineTransform3D(varargin)
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
        z = point(:, 3);
        
        % compute position wrt to the grid vertices
        xg = (x - this.gridOrigin(1)) / this.gridSpacing(1) + 1;
        yg = (y - this.gridOrigin(2)) / this.gridSpacing(2) + 1;
        zg = (z - this.gridOrigin(3)) / this.gridSpacing(3) + 1;
        
        % compute indices of values within interpolation area
        isInsideX = xg>=2 & xg<this.gridSize(1)-1;
        isInsideY = yg>=2 & yg<this.gridSize(2)-1;
        isInsideZ = zg>=2 & zg<this.gridSize(3)-1;
        isInside = isInsideX & isInsideY & isInsideZ;
        
        xg = xg(isInside);
        yg = yg(isInside);
        zg = zg(isInside);
        
        xgi = floor(xg);
        ygi = floor(yg);
        zgi = floor(zg);
        
        dimXYZ = prod(this.gridSize);

       % initialize zeros translation vector
        dx = zeros(length(xg), 1);
        dy = zeros(length(xg), 1);
        dz = zeros(length(xg), 1);
        
        for i=-1:2
            for j=-1:2
                for k=-1:2
                    % coordinates of neighbor vertex
                    xv = xgi + i;
                    yv = ygi + j;
                    zv = zgi + k;
                    
                    % linear index of translation components
                    indX = sub2ind([this.gridSize], xv, yv, zv);
                    indY = indX + dimXYZ;
                    indZ = indX + 2*dimXYZ;
                    
                    % translation vector of the current vertex
                    dxv = this.params(indX)';
                    dyv = this.params(indY)';
                    dzv = this.params(indZ)';
                    
                    % update total translation component
                    b = beta3(xg - xv) .* beta3(yg - yv) .* beta3(zg - zv);
                    dx = dx + b.*dxv;
                    dy = dy + b.*dyv;
                    dz = dz + b.*dzv;
                end
            end
        end
        
        % update coordinates of transformed point
        point2 = point;
        point2(isInside, 1) = point(isInside, 1) + dx;
        point2(isInside, 2) = point(isInside, 2) + dy;
        point2(isInside, 3) = point(isInside, 3) + dz;
        
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
    
    function ux = getUx(this, x, y, z)
        ind = sub2ind([this.gridSize 3], x, y, z, 1);
        ux = this.params(ind);
    end
    
    function setUx(this, x, y, z, ux)
        ind = sub2ind([this.gridSize 3], x, y, z, 1);
        this.params(ind) = ux;
    end
    
    function uy = getUy(this, x, y, z)
        ind = sub2ind([this.gridSize 3], x, y, z, 2);
        uy = this.params(ind);
    end
    
    function setUy(this, x, y, z, uy)
        ind = sub2ind([this.gridSize 3], x, y, z, 2);
        this.params(ind) = uy;
    end
    
    function uz = getUz(this, x, y, z)
        ind = sub2ind([this.gridSize 3], x, y, z, 3);
        uz = this.params(ind);
    end
    
    function setUz(this, x, y, z, uz)
        ind = sub2ind([this.gridSize 3], x, y, z, 3);
        this.params(ind) = uz;
    end
    
    function drawGrid(this)
        
        % needs validation in the 3D case
        
        % Draw the transformed grid
        lx = (0:this.gridSize(1) - 1) * this.gridSpacing(1) + this.gridOrigin(1);
        ly = (0:this.gridSize(2) - 1) * this.gridSpacing(2) + this.gridOrigin(2);
        lz = (0:this.gridSize(3) - 1) * this.gridSpacing(3) + this.gridOrigin(3);
        
        % create base mesh
        [x y z] = meshgrid(lx, ly, lz);
        
        % add grid shifts
        x = permute(x, [2 1 3]) + reshape(this.params(1:end/3), this.gridSize);
        y = permute(y, [2 1 3]) + reshape(this.params(end/3+1:end*2/3), this.gridSize);
        z = permute(z, [2 1 3]) + reshape(this.params(end*2/3+1:end), this.gridSize);
        
        inds = reshape((1:numel(x)), this.gridSize);
        
        % create vertex array
        v = [x(:) y(:) z(:)];
        
        % edges in direction x
        ne1 = this.gridSize(1) * (this.gridSize(2) - 1) * this.gridSize(3);
        v1 = reshape(inds(:, 1:end-1, :), [ne1 1]);
        v2 = reshape(inds(:,   2:end, :), [ne1 1]);
        e1 = [v1 v2];
        
        % edges in direction y
        ne2 = (this.gridSize(1) - 1) * this.gridSize(2) * this.gridSize(3);
        v1 = reshape(inds(1:end-1, :, :), [ne2 1]);
        v2 = reshape(inds(  2:end, :, :), [ne2 1]);
        e2 = [v1 v2];
        
        % edges in direction y
        ne3 = this.gridSize(1) * this.gridSize(2) * (this.gridSize(3) - 1);
        v1 = reshape(inds( :, :, 1:end-1), [ne3 1]);
        v2 = reshape(inds( :, :,   2:end), [ne3 1]);
        e3 = [v1 v2];

        % create edge array
        e = cat(1, e1, e2, e3);

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
