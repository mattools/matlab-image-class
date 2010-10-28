classdef ParametricFunction < handle
%PARAMETRICFUNCTION  One-line description here, please.
%
%   output = ParametricFunction(input)
%
%   Example
%   ParametricFunction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Abstract methods
methods (Abstract)
    setParameters(this, params)
    % Setup the parameters of the object
    
    res = computeValue(this)
    % Compute the value using the actual parameters (do not change state)
    
end % abstract methods

methods
    function res = evaluate(this, params)
        % basic implementation of evaluate function
        % this make possible the call in an Optimization procedure.
        this.setParameters(params);
        res = this.computeValue();
    end
    
end % base implementation

end % classdef


