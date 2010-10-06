classdef Optimizer < handle
%OPTIMIZER Single-value optimizer
%
%   output = Optimizer(input)
%
%   Example
%   Optimizer
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    % the current set of parameters
    params;

    % the function to minimize
    costFunction;
    
    % the fucntion that will be called at each iteration
    outputFunction = [];
    
    % Specifies which information will be displayed at each iteration
    displayMode = 'iter';
end

%% Constructor
methods
    
end

%% Abstract methods
methods (Abstract)
    varargout = optimize(varargin)
    %OPTIMIZE Start the optimizer until an end condition is reached
end

%% General methods
methods
    function params = getParameters(this)
        params = this.params;
    end
    
    function setParameters(this, params)
        this.params = params;
    end
    
    function fun = getCostFunction(this)
        fun = this.costFunction;
    end
    
    function setCostFunction(this, fun)
        this.costFunction = fun;
    end
    
    function fun = getOutputFunction(this)
        fun = this.outputFunction;
    end
    
    function setOutputFunction(this, fun)
        this.outputFunction = fun;
    end
    
    function mode = getDisplayMode(this)
        mode = this.displayMode;
    end
    
    function setDisplayMode(this, mode)
        this.displayMode = mode;
    end
end

end % classdef
