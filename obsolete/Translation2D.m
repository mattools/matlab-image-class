classdef Translation2D < Transform2D & AffineTransform
%TRANSFORM2D  Compose several transforms to create a new transform
%   output = ParametricTransform2D(input)
%
%   Example
%   ParametricTransform2D
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
    % translation along x-coordinate
    tx = 0;
    % translation along y-coordinate
    ty = 0;
end

%% Abstract methods
methods
    function this = Translation2D(varargin)
        % class constructor
        
        if nargin==0
            % empty constructor, nothing to do
            return;
        end
        
        if isa(varargin{1}, 'Translation2D')
            % copy constructor
            var = varargin{1};
            this.tx = var.tx;
            this.ty = var.ty;
        elseif isnumeric(varargin{1})
           var = varargin{1};
           if size(var, 2) == 1
               % initialize with separate parameters
               this.tx = var;
               this.ty = varargin{2};
           else
               % initialize with bundled parameters
               this.tx = var(1);
               this.ty = var(2);
           end
        else
            error('Wrong parameter when constructing a Composed transform');
        end
    end
    
    function mat = getAffineMatrix(this)
        % Returns the 3*3 affine matrix that represents this transform
        mat = [ ...
            1 0 this.tx; ...
            0 1 this.ty; ...
            0 0 1];
    end
end % end methods

end % end classdef
