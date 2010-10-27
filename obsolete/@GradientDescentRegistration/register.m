function [params metricValue] = register(this)
%REGISTER Run the registration algorithm



this.checkFieldsInitialization();

% create the metric if it is empty
if isempty(this.metric)
    this.initializeSSDMetric();
end

% ensure parameters are valid
if isempty(this.params)
    this.params = this.transfo.getParameters();
end

% ensure parameter scaling is valid
if isempty(this.paramScales)
    this.paramScales = ones(size(this.params));
end
if sum(size(this.params)~=size(this.paramScales))>0
    error('Scaling vector should have same size as parameter vector');
end
    
   
%% Main processing

% Main iteration    
for i=1:this.nIter
    if this.verbose
        fprintf('iteration %d / %d\n', i, this.nIter);
    end
    
    % setup model
    this.transfo.setParameters(this.params);
    
    % update test points of the metric
    %TODO: add possibility to change points at each iteration
    this.metric.setPoints(this.points);
    
    % update metric
    [value deriv] = this.metric.computeValueAndGradient(...
        this.transfo, this.gradientImages{:});
    
    % adjust derivative vector with respect to parameter scaling
    deriv = deriv./this.paramScales;
    
    % direction de recherche (on inverse car on cherche minimum)
    direction = -deriv/norm(deriv);
    
    % compute step depending on current iteration
    % TODO: use a more generic approach
    step = this.step0*exp(-i/this.tau);
    
    % compute new set of parameters
    this.params = this.params + direction*step;
    
    % Call an output function for processing abour current point
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
metricValue = value;

