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
% Created: 2010-11-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% Notify beginning of optimization
this.notify('OptimizationStarted');

params = this.params;
if ~isempty(this.initialParameters)
    params = this.initialParameters;
end

nParams = length(params);
variab  = this.parameterVariability;


if length(variab)~=nParams
    warning('oolip:NonInitializedParameter',...
        'Variability not specified, use default variability');
    variab = ones(size(params));
    this.parameterVariability = variab;
end

% generate nValues values between 0 and 1, avoiding bouds
pv = linspace(0, 1, this.nValues+2);
pv = pv(2:end-1);

for i = 1:this.nIter
    for p = 1:nParams
        % choose a set of values distributed around the current value
        % with a gaussian distribution
        paramValues = norminv(pv, params(p), variab(p));
        
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

