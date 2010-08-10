classdef NearestNeighborInterpolator3D < ImageInterpolator3D
%NEARESTNEIGHBORINTERPOLATOR3D  One-line description here, please.
%   output = NearestNeighborInterpolator3D(input)
%
%   Example
%   NearestNeighborInterpolator3D
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Declaration of class properties
properties
    % inner image
    image;
end

%% Constructors
methods
    function this = NearestNeighborInterpolator2D(varargin)
        % Constructs a new NearestNeighborInterpolator2D object.
        % interp = LinearInterpolator(IMG);
        % with IMG being a Image2D.
        if isa(varargin{1}, 'NearestNeighborInterpolator3D')
            % copy constructor
            var = varargin{1};
            this.image = var.image;
        elseif isa(varargin{1}, 'Image3D')
            % copy constructor
            this.image = varargin{1};
        else
            error('Wrong parameter when constructing a nearest neighbor interpolator');
        end
    end % constructor declaration
end % constructors

%% General methods

methods
    function img = getImage(this)
        % Returns the inner image of the interpolator
        img = this.image;
    end
    
    function [val isInside] = evaluateAtIndex(this, index, varargin)
        % Evaluate the value of an image for a point given in image coord
        
        % eventually convert inputs from x and y to a list of image coord
        dim = [size(index,1) 1];
        if length(varargin)>1
            var1 = varargin{1};
            var2 = varargin{2};
            if sum(size(var1)~=size(index))==0
                % keep dimension of original array
                dim = size(index);
                % create a linear array of indices
                index = [index(:) var1(:) var2(:)];
            end
        end
        
        val = ones(dim)*NaN;
        
        % extract x and y
        xt = index(:, 1);
        yt = index(:, 2);
        zt = index(:, 3);

        % select points located inside interpolation area
        % (smaller than image size)
        siz = this.image.getSize();
        isBefore    = sum(index<-.5, 2)<0;
        isAfter     = sum(index>=(siz(ones(N,1), :)-.5), 2)>0;
        isInside = ~(isBefore | isAfter);
        isInside = reshape(isInside, dim);

        xt = xt(isInside);
        yt = yt(isInside);
        zt = zt(isInside);
        
        % indices of pixels before and after in each direction
        i1 = round(xt);
        j1 = round(yt);
        k1 = round(zt);
        
        % values of the nearest neighbor
        val(isInside) = double(this.image.getPixels(i1, j1, k1));
        
    end

    function [val isInside] = evaluate(this, point, varargin)
        % Evaluate intensity of image at a given physical position
        %
        % VAL = INTERP.evaluate(POS);
        % where POS is a Nx2 array containing alues of x- and y-coordinates
        % of positions to evaluate image, return an array with as many
        % values as POS.
        %
        % VAL = INTERP.evaluate(X, Y)
        % X and Y should be the same size. The result VAL has the same size
        % as X and Y.
        %
        % [VAL INSIDE] = INTERP.evaluate(...)
        % Also return a boolean flag the same size as VAL indicating
        % whether or not the given position as located inside the
        % evaluation frame.
        %
        
        
        % eventually convert inputs from x, y, z to a list of points
        dim = [size(point,1) 1];
        if length(varargin)>1
            var1 = varargin{1};
            var2 = varargin{2};
            if sum(size(var1)~=size(point))==0
                % keep dimension of original array
                dim = size(point);
                % create a linear array of indices
                point = [point(:) var1(:) var2(:)];
            end
        end
        
        % Evaluates image value for a given position
        coord = this.image.pointToContinuousIndex(point);
        
        % Create default result image
        defaultValue = NaN;
        val = ones(dim)*defaultValue;
        
        % extract x and y
        xt = coord(:, 1);
        yt = coord(:, 2);
        zt = coord(:, 3);
        
        % select points located inside interpolation area
        % (smaller than image physical size)
        siz = this.image.getSize();
        isBefore    = sum(coord<0, 2)<0;
        isAfter     = sum(coord>=(siz(ones(N,1), :)-1), 2)>0;
        isInside = ~(isBefore | isAfter);
        isInside = reshape(isInside, dim);
        
        % keep only valid indices for computation
        xt = xt(isInside);
        yt = yt(isInside);
        zt = zt(isInside);
        
        % indices of pixels before and after in each direction
        i1 = floor(xt);
        j1 = floor(yt);
        k1 = floor(zt);

        % values of the nearest neighbor
        val(isInside) = double(this.image.getPixels(i1, j1, k1));
    end
    
end % methods

end % classdef