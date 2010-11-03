classdef ParameterizedFunctionEvaluator < SingleValuedCostFunction
%PARAMETERIZEDFUNCTIONEVALUATOR  One-line description here, please.
%
%   output = ParameterizedFunctionEvaluator(input)
%
%   Example
%   ParameterizedFunctionEvaluator
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Properties
properties
    transform;
    baseFunction;
end


%% Constructor
methods
    function this = ParameterizedFunctionEvaluator(transform, baseFunction)
        %Constructor for a new MetricEvaluator
        % THIS = MetricEvaluator(TRANSFO, METRIC)
        
        % test class of transform
        if ~isa(transform, 'ParametricObject')
            error('First argument must be a parametric object');
        end
        
        this.transform = transform;
        this.baseFunction = baseFunction;
      
    end % constructor
 
end % construction function
 

%% General methods
methods
 
    function [res grad] = evaluate(this, params)
        % Update transform parameters, and compute function value (and grad)
        
        % update params
        setParameters(this.transform, params);
        
        % compute value and eventually graident
        if nargout<=1
            res = computeValue(this.baseFunction);
        else
            [res grad] = computeValueAndGradient(this.baseFunction);
        end
    end
end % general methods
 
end % classdef

