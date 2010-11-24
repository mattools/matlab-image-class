classdef GaussianLinearSearchOptimizer < Optimizer
%GaussianLinearSearchOptimizer Optimize each parameter individually
%
%   output = GaussianLinearSearchOptimizer(input)
%
%   Example
%   GaussianLinearSearchOptimizer
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


properties
    % the 'variability' of each parameter. Default is 1.
    parameterVariability;
    
    % number of values to compute on each param
    nValues = 50;
    
    % maximum number of iterations
    nIter = 10;
    
end

methods
    function this = GaussianLinearSearchOptimizer(varargin)
        this = this@Optimizer(varargin{:});
    end
end

end