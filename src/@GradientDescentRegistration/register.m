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
    [ssd deriv] = this.metric.computeValueAndGradient(...
        this.transfo, this.gradientImages{:});
    
    % direction de recherche (on inverse car on cherche minimum)
    direction = -deriv/norm(deriv);
    
    % compute step depending on current iteration
    % TODO: use a more generic approach
    step = this.step0*exp(-i/this.tau);
    
    % compute new set of parameters
    this.params = this.params + direction*step;
    
    % Call an output function for processing abour current point
    if ~isempty(this.outputFunction)
        stop = this.outputFunction(this.params, [], []);
        if stop
            break;
        end
    end
end

params = this.params;
metricValue = ssd;

