classdef ConstantCostFunction < CostFunction
%CONSTANTCOSTFUNCTION Dummy cost function used for tests
%
%   CCF = ConstantCostFunction();
%
%   Example
%   CCF = ConstantCostFunction();
%   fval = CCF.evaluate([1 2 3]);
%   fval = 
%       1
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-01-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


methods 
    function varargout = evaluate(this, params) %#ok<MANU>
        % Returns the same value (here, 1), whatever the param vector
        fval = 1;
        if nargout<=1
            % return simply the evaluated function
            varargout = {fval};
        else
            % also returns the gradient, that is here equal to the null
            % vector
            varargout = {fval, zeros(size(params))};
        end
    end    
end

end
