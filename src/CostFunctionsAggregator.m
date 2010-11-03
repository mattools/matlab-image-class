classdef CostFunctionsAggregator < SingleValuedCostFunction
%COSTFUNCTIONSAGGREGATOR  One-line description here, please.
%
%   output = CostFunctionsAggregator(input)
%
%   Example
%   CostFunctionsAggregator
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
    costFunctions;
    
    weights;
end

%% Constructor
methods
    function this = CostFunctionsAggregator(varargin)
        
        if nargin<1
            error('Need at least one input argument');
        end
        
        var = varargin{1};
        if ~iscell(var)
            error('First argument must be a cell array of cost functions');
        end
        
        this.costFunctions = varargin{1};
        
        if nargin>1
            this.weights = varargin{2};
        else
            this.weights = ones(1, length(this.costFunctions));
        end
    end
    
end % constructors


%% General methods
methods
    function value = evaluate(this, params)
        
        nFP = length(params);
        nF  = length(this.costFunctions);
        nP  = nFP/nF;
        
        for i=1:nF
            param_i = params((i-1)*nP+1:i*NP);
            fun_i = this.costFunctions{i};
            value = value + fun_i.evaluate(param_i)*this.weights(i);
        end
        
    end
end


end
