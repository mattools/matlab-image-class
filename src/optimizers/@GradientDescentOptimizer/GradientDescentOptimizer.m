classdef GradientDescentOptimizer < Optimizer
%@GRADIENTDESCENTOPTIMIZER Gradient descent optimizer
%
%   output = @GradientDescentOptimizer(input)
%
%   Example
%   @GradientDescentOptimizer
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    %TODO: add gradient descent control
    nIter   = 200;
    
    tau     = 50;
    
    step0   = 1;
end

%% Constructor
methods
    function this = GradientDescentOptimizer(varargin)
        this = this@Optimizer(varargin{:});
    end
    
end


%% General methods
methods
end

end
