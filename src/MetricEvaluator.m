classdef MetricEvaluator < handle
%METRICEVALUATOR Evaluate a metric that depend on a parametric object
%
%   output = MetricEvaluator(input)
%
%   Example
%   MetricEvaluator
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

 
%% Properties
properties
    transform;
    metric;
end


%% Constructor
methods
    function this = MetricEvaluator(transform, metric)
        %Constructor for a new MetricEvaluator
        % THIS = MetricEvaluator(TRANSFO, METRIC)
        
        % test class of transform
        if ~isa(transform, 'ParametricTransform')
            error('First argument must be a parametric transform');
        end
        
        this.transform = transform;
        this.metric = metric;
      
    end % constructor
 
end % construction function
 

%% General methods
methods
 
    function [res grad] = evaluate(this, params)
        % Update transform parameters, and compute metric value (and grad)
        
        % uupdate params
        setParameters(this.transform, params);
        
        % compute value and eventually graident
        if nargout<=1
            res = computeValue(this.metric);
        else
            [res grad] = computeValueAndGradient(this.metric);
        end
    end
end % general methods
 
end % classdef

