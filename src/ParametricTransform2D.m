classdef ParametricTransform2D < Transform2D
%PARAMETRICTRANSFORM2D  Abstract class for parametric transform 2D->2D
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
    params;
end

%% Static methods
methods(Static)
end

%% Methods for managing parameters
methods
    function p = getParameters(this)
        % Returns the parameter vector of the transform
        p = this.params;
    end
    
    function setParameters(this, params)
        % Changes the parameter vector of the transform
        this.params = params;
    end
    
    function Np = getParameterLength(this)
        % Returns the length of the vector parameter
        Np = length(this.params);
    end
end

end
