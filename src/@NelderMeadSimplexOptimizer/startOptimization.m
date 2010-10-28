function [params value] = startOptimization(this)
%STARTOPTIMIZATION  Run the optimizer, and return optimized parameters
%
%   output = startOptimization(input)
%
%   Example
%   startOptimization
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% Notify beginning of optimization
this.notify('OptimizationStarted');

% some options
options = optimset(...
    'TolX', 1e-2, ...
    'MaxIter', this.nIter, ...
    'Display', this.displayMode);

% Setup the eventual output function
if ~isempty(this.outputFunction)
    options.OutputFcn = this.outputFunction;
end
options.OutputFcn = @outputFunctionHandler;

% resume parameter array
if ~isempty(this.initialParameters)
    this.params = this.initialParameters;
end

% run the simplex optimizer, by calling Matlab optimisation function
[params value] = fminsearch(this.costFunction, this.params, options);

% update inner data
this.params = params;
this.value = value;

% Notify the end of optimization
this.notify('OptimizationTerminated');


    function stop = outputFunctionHandler(x, optimValues, state, varargin)
        
        stop = false;
        % If an input function was specified, propagates processing
        if ~isempty(this.outputFunction)
            stop = this.outputFunction(x, optimValues, state);
        end
        
        % update current values
        this.params = x;
        this.value = optimValues.fval;
        
        % Notify iteration
        if strcmp(state, 'iter')
            this.notify('OptimizationIterated');
        end
    end

end