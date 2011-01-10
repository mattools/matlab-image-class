function [params value converged output] = startOptimization(this)
%STARTOPTIMIZATION Run the optimizer, and return optimized parameters
%
%   PARAMS = startOptimization(OPTIM)
%   PARAMS = OPTIM.startOptimization()
%   Returns the optimized parameter set.
%
%   [PARAMS VALUE] = startOptimization(OPTIM)
%   [PARAMS VALUE] = OPTIM.startOptimization()
%   Returns the optimized parameter set and the best function evaluation.
%
%   [PARAMS VALUE CONVERGED] = startOptimization(OPTIM)
%   [PARAMS VALUE CONVERGED] = OPTIM.startOptimization()
%   Also returns a boolean indicating whether the algorithm converged or
%   not.
%
%   [PARAMS VALUE CONVERGED OUTPUT] = startOptimization(OPTIM)
%   [PARAMS VALUE CONVERGED OUTPUT] = OPTIM.startOptimization()
%   Also returns a data structure containing information about the
%   algorithm. See documentation of 'fminsearch' for details.
%
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
% Created: 2011-01-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%TODO: provide psb to start optimization with a specified simplex

TINY = 1e-10;


%% Initialization

% Notify beginning of optimization
this.notify('OptimizationStarted');

% initialize the simplex.
initializeSimplex(this);

% state of the algorithm
exitMessage = 'Algorithm started';
converged = false;


%% Main loop

% infinite loop
iter = 1;
while true
    % first, determines the indices of points with the highest (i.e.
    % worst), next highest, and lowest (i.e. best) values. 
    [dummy indices] = sort(this.evals); %#ok<ASGLU>
    indLow  = indices(1);
    indHigh = indices(end);
    indNext = indices(end-1);
    
    % update optimized value and position
    this.params = this.simplex(indLow, :);
    this.value  = this.evals(indLow);
    
    % compute relative difference between highest and lowest
    fLow    = this.evals(indLow);
    fHigh   = this.evals(indHigh);
    rtol = 2 * abs(fHigh - fLow) / (abs(fHigh) + abs(fLow) + TINY);

    % termination with function evaluation
    if rtol < this.ftol
        exitMessage = sprintf('Function converged with relative tolerance %g', this.ftol);
        converged = true;
        break;
    end
    
    % begin a new iteration
    
    % first extrapolate by a factor -1 through the face of the simplex
    % opposite to the highest point.
    [xTry fTry] = this.evaluateReflection(indHigh, -1);
    
    % if the value at the evaluated position is better than current
    % highest value, then replace the highest value
    if fTry < this.evals(indHigh)
        this.updateSimplex(indHigh, xTry, fTry);
        if strcmp(this.displayMode, 'iter')
            disp('reflection');
        end
        this.notify('OptimizationIterated');
    end

    
    if fTry <= this.evals(indLow)
        % if new evaluation is better than current minimum, try to expand
        [xTry fTry] = this.evaluateReflection(indHigh, 2);
        
        if fTry < this.evals(indHigh)
            % expansion was successful
            this.updateSimplex(indHigh, xTry, fTry);
            if strcmp(this.displayMode, 'iter')
                disp('expansion');
            end
            this.notify('OptimizationIterated');
        end
    
    elseif fTry >= this.evals(indNext)
        % if new evaluation is worse than the second-highest point, look
        % for an intermediate point (i.e. do a one-dimensional contraction)
        [xTry fTry] = this.evaluateReflection(indHigh, .5);
        
        if fTry < this.evals(indHigh)
            % contraction was successful
            this.updateSimplex(indHigh, xTry, fTry);
            if strcmp(this.displayMode, 'iter')
                disp('contraction');
            end
            this.notify('OptimizationIterated');
            
        else
            % 1D contraction was not successful, so perform a shrink
            % (multidimensional contraction) around lowest point
            this.contractSimplex(indLow);
            if strcmp(this.displayMode, 'iter')
                disp('shrink');
            end
            this.notify('OptimizationIterated');
        end
        
    end
    
    % termination with number of iterations
    if iter > this.nIter
        exitMessage = sprintf('Iteration number reached maximum allowed value: %d', this.nIter);
        break;
    end

    iter = iter + 1;
end % main iteration loop


%% Terminates

if converged
    if strmatch(this.displayMode, {'iter', 'final'})
        disp(exitMessage);
    end
else
    if strmatch(this.displayMode, {'iter', 'final', 'notify'})
        disp(exitMessage);
    end
end

% send termination event
this.notify('OptimizationTerminated');

% return the current state of the optimizer
params  = this.params;
value   = this.value;

% create output structure
output.algorithm    = '';
output.funcCount    = this.numFunEvals;
output.iterations   = iter;
output.message      = exitMessage;

