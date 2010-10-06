function [params value] = optimize(this)
%OPTIMIZE Run the otpimization algorithm


% ensure there is a valid direction set
if isempty(this.directionSet)
    this.initDirectionSet();
end


% default tolerance
tol = 1e-5;

nDirs = size(this.directionSet, 1);

% main loop
% Use linear search in a set of directions that span the parameters of the
% first transform.
% The same process could be obteained by calling 'directionSetMinimizer'.
dirIndex = 1;
for i = 1:this.nIter
    if this.verbose
        disp(sprintf('iteration %d / %d', i, this.nIter)); %#ok<DSPS>
    end
    
    % current direction
    dir = this.directionSet(dirIndex, :);
    
    % update direction index
    dirIndex = mod(dirIndex, nDirs) + 1;
    
    % use a function handle of 1 variable
    fun1 = @(t) this.costFunction(this.params + t*dir);
    
    % guess initial bounds of the function
    ax = 0;
    bx = 1;
    [ax bx cx] = fMinBracket(fun1, ax, bx);
    
    % search minimum along dimension DIR
    [tmin value] = brentLineSearch(fun1, ax, bx, cx, tol);
    
    % construct new optimal point
    this.params = this.params + tmin*dir;
    
    % Call an output function for processing current point
    if ~isempty(this.outputFunction)
        % setup optim values
        optimValues.fval = value;
        optimValues.iteration = i;
        optimValues.procedure = 'Linear search';
        
        % call output function with appropriate parameters
        stop = this.outputFunction(this.params, optimValues, 'iter');
        if stop
            break;
        end
    end
end

% format output arguments
params = this.params;


% we need a final end because nested functions are used
end
