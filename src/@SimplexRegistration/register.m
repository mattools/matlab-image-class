function [params metricValue] = register(this)
%REGISTER Run the simplex-based registration


%% Initialisations

this.checkFieldsInitialization();

% create the metric if it is empty
if isempty(this.metric)
    this.initializeSSDMetric();
end

% ensure parameters are valid
if isempty(this.params)
    this.params = this.transfo.getParameters();
end

   
%% Main processing

% create a function handle for minimization
minimizer = @(x) evaluateParametricMetric(x, this.transfo, this.metric);

% some options
options = optimset('TolX', 1e-2, 'MaxIter', this.nIter, 'Display', 'iter');

% Setup the eventual output function
if ~isempty(this.outputFunction)
    options.OutputFcn = this.outputFunction;
end

% run the simplex optimizer
tic;
[params metricValue] = fminsearch(minimizer, this.params, options);
elapsedTime = toc;

disp(sprintf('Elapsed time: %7.5f s', elapsedTime)); %#ok<DSPS>
disp('Optimized parameters: ');
disp(params);

this.params = params;


%% Utilitary function

function res = evaluateParametricMetric(params, transfo, metric)
%EVALUATEPARAMETRICMETRIC Function handle for minimisation
transfo.setParameters(params);
res = metric.computeValue();
