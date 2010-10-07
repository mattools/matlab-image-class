classdef NelderMeadSimplexOptimizer < Optimizer
%NELDERMEADSIMPLEXOPTIMIZER  One-line description here, please.
%
%   output = NelderMeadSimplexOptimizer(input)
%
%   Example
%   % Run the simplex otpimizer on the Rosenbrock function
%     optimizer = NelderMeadSimplexOptimizer;
%     optimizer.setCostFunction(@rosenbrock);
%     optimizer.setParameters([0 0]);
%     [xOpt value] = optimizer.startOptimization();
%     xOpt
%       xOpt =
%           0.9993    0.9984
%     value
%       value =
%           5.5924e-006
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Properties
properties
    nIter = 200;
end

%% Constructor
methods
    function this = NelderMeadSimplexOptimizer(varargin)
        this = this@Optimizer(varargin{:});
    end
end

end