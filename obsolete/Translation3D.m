classdef Translation3D < AffineTransform & Transform3D
%TRANSLATION3D  Create a 3D Translation
%   output = ParametricTransform2D(input)
%
%   Example
%   t = Translation3D([10 20 30]);
%   t.transformPoint([10 10 10])
%   ans =
%       [20 30 40]
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-04-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    % the set of inner parameters of the transform
    tx = 0;
    ty = 0;
    tz = 0;
end

%% Abstract methods
methods
    function this = Translation3D(varargin)
        % class constructor
        
        if nargin==0
            % empty constructor, nothing to do
            return;
        end
        
        if isa(varargin{1}, 'Translation3D')
            % copy constructor
            var = varargin{1};
            this.tx = var.tx;
            this.ty = var.ty;
            this.tz = var.tz;
        elseif isnumeric(varargin{1})
           var = varargin{1};
           if size(var, 2) == 1
               this.tx = var;
               this.ty = varargin{2};
               this.tz = varargin{3};
           else
               this.tx = var(1);
               this.ty = var(2);
               this.tz = var(3);
           end
        else
            error('Wrong parameter when constructing a Composed transform');
        end
    end
    
    function p = transformPoint(this, point)
        p = [point(:,1)+this.tx point(:,2)+this.ty point(:,3)+this.tz];
    end
    
    function vector = transformVector(this, vector, position) %#ok<MANU,INUSD>
        % do nothing, as vector components are not translated
    end
    
    function mat = getAffineMatrix(this)
        % Returns the 4*4 affine matrix that represents this transform
        mat = [ ...
            1 0 0 this.tx; ...
            0 1 0 this.ty; ...
            0 0 1 this.tz; ...
            0 0 0 0 1];
    end
end

end
