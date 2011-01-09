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

%TODO: make simplex a field, and provide psb to start optimization with
% specified simplex

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
    ilo     = indices(1);
    ihi     = indices(end);
    inhi    = indices(end-1);
    
    % update optimized value and position
    this.params = this.simplex(ilo, :);
    this.value  = this.evals(ilo);
    
    % compute relative difference between highest and lowest
    yLow    = this.evals(ilo);
    yHigh   = this.evals(ihi);
    rtol = 2 * abs(yHigh - yLow) / (abs(yHigh) + abs(yLow) + TINY);

    % termination with function evaluation
    if rtol < this.ftol
        break;
    end
    
    % begin a new iteration
    
    % first extrapolate by a factor -1 through the face of the simplex
    % opposite to the highest point.
    [pTry yTry] = this.evaluateReflection(ihi, -1);
    
    % if the value at the evaluated position is better than current
    % highest value, then replace the highest value
    if yTry < this.evals(ihi)
        disp('reflection');
        this.updateSimplex(ihi, pTry, yTry)
    end

    
    if yTry <= this.evals(ilo)
        % if new evaluation is better than current minimum, try to expand
        [pTry yTry] = this.evaluateReflection(ihi, 2);
        
        if yTry < this.evals(ihi)
            % expansion was successful
            disp('expansion');
            this.updateSimplex(ihi, pTry, yTry);
        end
    
    elseif yTry >= this.evals(inhi)
        % if new evaluation is worse than the second-highest point, look
        % for an intermediate point (i.e. do a one-dimensional contraction)
        [pTry yTry] = this.evaluateReflection(ihi, .5);
        
        if yTry < this.evals(ihi)
            % contraction was successful
            disp('contraction');
            this.updateSimplex(ihi, pTry, yTry);
            
        else
            % 1D contraction was not successful, so perform a
            % multidimensional contraction
            disp('multiple contraction');
            this.contractSimplex(this, ilo);
        end
        
    end
    
    % termination with number of iterations
    if iter > this.nIter
        break;
    end

    iter = iter + 1;
    
    % send iteration event
    this.notify('OptimizationIterated');

end % main iteration loop


%% Terminates

% send termination event
this.notify('OptimizationTerminated');

% return the current state of the optimizer
params = this.params;
value = this.value;

end


