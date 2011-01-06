classdef CostFunction < handle
%COSTFUNCTION Evaluate a numeric value from a parameter vector
%
%   This is an abstract class that is derived in more specialized classes.
%
%   Usage:
%   % create a dummy cost function
%   Fun = ConstantCostFunction();
%   % evaluates for a dummy vector theta
%   theta = [1 2 3];
%   fval = Fun.evaluate(theta)
%   fval = 
%       1
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

methods (Abstract)
    cost = evaluate(this, params)
    % Evaluates the cost function for the given parameter vector
    
end

end
