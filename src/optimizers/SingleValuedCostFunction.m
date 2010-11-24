classdef SingleValuedCostFunction < handle
%SINGLEVALUEDCOSTFUNCTION Evaluates a numeric value from a parameter vector
%
%   output = SingleValuedCostFunction(input)
%
%   Example
%   SingleValuedCostFunction
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
