classdef ComposedTransform < Transform
%COMPOSEDTRANSFORM  Compose several transforms to create a new transform
%   output = ComposedTransform(input)
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
    % the set of encapsulated transforms
    transforms;
end

%% Constructor
methods
    function this = ComposedTransform(varargin)
        % class constructor
        % T = ComposedTransform(T1, T2);
        
        if isa(varargin{1}, 'ComposedTransform')
            % copy constructor
            var = varargin{1};
            this.transforms = var.transforms;
        elseif isa(varargin{1}, 'Transform')
            % initialize tranform array
            nbTrans = length(varargin);
            this.transforms = cell(nbTrans, 1);
            for i=1:nbTrans
                this.transforms{i} = varargin{i};
            end
        else
            error('Wrong parameter when constructing a Composed transform');
        end
    end % constructor
end


%% Methods implementing Transform interface
methods
    function point = transformPoint(this, point)
        for i=1:length(this.transforms)
            point = this.transforms{i}.transformPoint(point);
        end
    end
    
    function vector = transformVector(this, vector, position)
        for i=1:length(this.transforms)
            vector = this.transforms{i}.transformVector(vector, position);
        end
    end
    
    function jacobian = getJacobian(this, point)
        % Compute jacobian matrix, i.e. derivatives for coordinate
        % jacob(i,j) = d x_i / d x_j
        jacobian = this.transforms{1}.getJacobian(point);
        for i=2:length(this.transforms)
            jacobian = this.transforms{i}.getJacobian(point)*jacobian;
        end
    end
end % methods

end % classdef
