function [params value] = startOptimization(this)
%STARTOPTIMIZATION Start the gradient descent optimization algorithm
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
% Created: 2010-10-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% optimisation parameters
step0   = this.step0;
nIter   = this.nIter;
tau     = this.tau;

% allocate memory
step = zeros(nIter, 1);

% setup parameters to initial value
if ~isempty(this.initialParameters)
    this.params = this.initialParameters;
end

for i=1:nIter
    fprintf('iter %d / %d\n', i, nIter);
    
    % update metric
    [value deriv] = this.costFunction(this.params);
    
    % if scales are initialized, scales the derivative
    if ~isempty(this.parameterScales)
        % dimension check
        if length(this.parameterScales) ~= length(this.params)
            error('Scaling parameters should have same size as parameters');
        end
        
        deriv = deriv ./ this.parameterScales;
    end
    
    % search direction (with a minus sign because we are looking for the
    % minimum)
    direction = -deriv/norm(deriv);
    
    % compute step depending on current iteration
    step(i) = step0*exp(-i/tau);
    
    % compute new set of parameters
    this.params = this.params + direction*step(i);
    
    % Call an output function for processing abour current point
    if ~isempty(this.outputFunction)
        % setup optim values
        optimValues.fval = value;
        optimValues.iteration = i;
        optimValues.procedure = 'Gradient descent';
        
        % call output function with appropriate parameters
        stop = this.outputFunction(this.params, optimValues, 'iter');
        if stop
            break;
        end
    end
end

% returns the current set of parameters
params = this.params;

