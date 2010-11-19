function [params value] = startOptimization(this)
%STARTOPTIMIZATION  Run the optimizer, and return optimized parameters
%
%   PARAMS = startOptimization(OPTIM)
%   PARAMS = OPTIM.startOptimization()
%
%   [PARAMS VALUE] = startOptimization(OPTIM)
%   [PARAMS VALUE] = OPTIM.startOptimization()
%
%   Example
%   StartOptimization
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% Notify beginning of optimization
this.notify('OptimizationStarted');

params = this.params;
if ~isempty(this.initialParameters)
    params = this.initialParameters;
end

nParams = length(params);
bounds = this.bounds;

if size(bounds, 1)~=nParams || size(bounds, 2)~=2
    warning('oolip:NonInitializedParameter',...
        'Bounds not specified, use default bounds');
    bounds = [params'-10 params'+10];
end


for i = 1:this.nIter
    for p = 1:nParams
        % choose a set of values
        par0 = bounds(p, 1);
        par1 = bounds(p, 2);
        paramValues = linspace(par0, par1, this.nValues);
        
        % compute the metric for the given param
        res = zeros(this.nValues, 1);
        for k = 1:this.nValues
            params(p) = paramValues(k);
            res(k) = this.costFunction(params);
        end
        
        [value bestK] = min(res);
        params(p) = paramValues(bestK);
        
        % update optimizer internal state
        this.params = params;
        this.value  = value;
        
        % notify
        this.notify('OptimizationIterated');
    end 
end

% update inner data
this.params = params;
this.value = value;

% Notify the end of optimization
this.notify('OptimizationTerminated');

