classdef ComposedTransform2D < Transform2D
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
    % the set of inner parameters of the transform
    transforms;
end

%% Abstract methods
methods
    function this = ComposedTransform2D(varargin)
        % class constructor
        if isa(varargin{1}, 'ComposedTransform2D')
            % copy constructor
            var = varargin{1};
            this.transforms = var.transforms;
        elseif isa(varargin{1}, 'Transform2D')
            % initialize tranform array
            nbTrans = length(varargin);
            this.transforms = cell(nbTrans, 1);
            for i=1:nbTrans
                this.transforms{i} = varargin{i};
            end
        else
            error('Wrong parameter when constructing a Composed transform');
        end
    end
    
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
end

end
