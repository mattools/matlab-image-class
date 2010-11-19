classdef BoundedMultiLinearOptimizer < Optimizer
%BOUNDEDMULTILINEAROPTIMIZER Optimize each parameter individually
%
%   output = BoundedMultiLinearOptimizer(input)
%
%   Example
%   BoundedMultiLinearOptimizer
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-19,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


properties
    % the bounds for each parameter. Should be a Np-by-2 array.
    bounds;
    
    % number of values to compute on each param
    nValues = 50;
    
    % maximum number of iterations
    nIter = 10;
    
end

methods
    function this = BoundedMultiLinearOptimizer(varargin)
        this = this@Optimizer(varargin{:});
    end
end

end