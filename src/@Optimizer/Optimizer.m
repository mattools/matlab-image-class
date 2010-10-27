classdef Optimizer < handle
%OPTIMIZER Single-value optimizer
%
%   output = Optimizer(input)
%
%   Example
%   Optimizer
%
%   See also
%   NelderMeadSimplexOptimizer, MultiLinearSearchOptimizer
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    % the function to minimize
    costFunction;
    
    % the initial set of parameters
    initialParameters = [];
    
    % the current set of parameters
    params;

    % the current value
    value; 
    
    % Some scaling of the parameters for homogeneization
    % (parameters will be divided by corresponding scale)
    parameterScales = [];
    
    % the fucntion that will be called at each iteration
    outputFunction = [];
    
    % Specifies which information will be displayed at each iteration
    displayMode = 'iter';
end

%% Events
events
    % notified when the optimization starts
    OptimizationStarted
    
    % notified when the an iteration is run
    OptimizationIterated
    
    % notified when the optimization finishes
    OptimizationTerminated
end

%% Constructor
methods
    % no need to define anything special
end

%% Abstract methods
methods (Abstract)
    varargout = startOptimization(varargin)
    %STARTOPTIMIZATION Start the optimizer until an end condition is reached
end

%% General methods
methods
    function params = getInitialParameters(this)
        params = this.initialParameters;
    end
    
    function setInitialParameters(this, params0)
        this.initialParameters = params0;
    end
    
    function params = getParameters(this)
        params = this.params;
    end
    
    function setParameters(this, params)
        this.params = params;
    end
    
    function scales = getParameterScales(this)
        scales = this.parameterScales;
    end
    
    function setParameterScales(this, scales)
        this.parameterScales = scales;
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

%% Listeners management
methods
    function addOptimizationListener(this, listener)
        %Adds an OptimizationListener to this optimizer
        %
        % usage: 
        %   addOptimizationListener(OPTIM, LISTENER);
        %   OPTIM is an instance of Optimizer
        %   LISTENER is an instance of OptimizationListener
        %
        
        % Check class of input
        if ~isa(listener, 'OptimizationListener')
            error('Input argument should be an instance of OptimizationListener');
        end
        
        % link function handles to events
        this.addlistener('OptimizationStarted', @listener.optimizationStarted);
        this.addlistener('OptimizationIterated', @listener.optimizationIterated);
        this.addlistener('OptimizationTerminated', @listener.optimizationTerminated);
        
    end
end

end % classdef
