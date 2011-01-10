function [params value] = startOptimization(this)
%STARTOPTIMIZATION Run the optimizer, and return optimized parameters
%
%   PARAMS = startOptimization(OPTIM)
%   PARAMS = OPTIM.startOptimization()
%
%   [PARAMS VALUE] = startOptimization(OPTIM)
%   [PARAMS VALUE] = OPTIM.startOptimization()
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

%TODO: provide psb to start optimization with a specified simplex

TINY = 1e-10;


%% Initialization

% Notify beginning of optimization
this.notify('OptimizationStarted');

% initialize the simplex.
initializeSimplex(this);


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
    yLow    = this.evals(indLow);
    yHigh   = this.evals(indHigh);
    rtol = 2 * abs(yHigh - yLow) / (abs(yHigh) + abs(yLow) + TINY);

    % termination with function evaluation
    if rtol < this.ftol
        break;
    end
    
    % begin a new iteration
    
    % first extrapolate by a factor -1 through the face of the simplex
    % opposite to the highest point.
    [pTry yTry] = this.evaluateReflection(indHigh, -1);
    
    % if the value at the evaluated position is better than current
    % highest value, then replace the highest value
    if yTry < this.evals(indHigh)
        this.updateSimplex(indHigh, pTry, yTry);
        if strcmp(this.displayMode, 'iter')
            disp('reflection');
        end
        this.notify('OptimizationIterated');
    end

    
    if yTry <= this.evals(indLow)
        % if new evaluation is better than current minimum, try to expand
        [pTry yTry] = this.evaluateReflection(indHigh, 2);
        
        if yTry < this.evals(indHigh)
            % expansion was successful
            this.updateSimplex(indHigh, pTry, yTry);
            if strcmp(this.displayMode, 'iter')
                disp('expansion');
            end
            this.notify('OptimizationIterated');
        end
    
    elseif yTry >= this.evals(indNext)
        % if new evaluation is worse than the second-highest point, look
        % for an intermediate point (i.e. do a one-dimensional contraction)
        [pTry yTry] = this.evaluateReflection(indHigh, .5);
        
        if yTry < this.evals(indHigh)
            % contraction was successful
            this.updateSimplex(indHigh, pTry, yTry);
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
        break;
    end

    iter = iter + 1;
    
%     % send iteration event
%     this.notify('OptimizationIterated');

end % main iteration loop


%% Terminates

% send termination event
this.notify('OptimizationTerminated');

% return the current state of the optimizer
params = this.params;
value = this.value;

