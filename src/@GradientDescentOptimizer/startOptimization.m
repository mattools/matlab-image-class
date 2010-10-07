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

for i=1:nIter
    fprintf('iter %d / %d\n', i, nIter);
    
    % update metric
    [value deriv] = this.costFunction(this.params);
    
    % direction de recherche (on inverse car on cherche minimum)
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

params = this.params;
