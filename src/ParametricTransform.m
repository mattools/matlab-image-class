classdef ParametricTransform < Transform & ParametricObject
%ParametricTransform  Abstract class for parametric transform ND->ND
%   output = ParametricTransform(input)
%
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-04-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Properties definition
properties
    % the set of inner parameters of the transform
    params;
    
    % the name of each parameter, stored to facilitate automatic plotting
    paramNames = {};
end

%% Methods for managing parameters
methods
    function p = getParameters(this)
        % Returns the parameter vector of the transform
        p = this.params;
    end
    
    function setParameters(this, params)
        % Changes the parameter vector of the transform
        this.params = params;
    end
    
    function Np = getParameterLength(this)
        % Returns the length of the vector parameter
        Np = length(this.params);
    end
    
    function name = getParameterName(this, paramIndex)
        % Return the name of the i-th parameter
        %
        % NAME = Transfo.getParameterName(PARAM_INDEX);
        % PARAM_INDEX is the parameter index, between 0 and the number of
        % parameters.
        %
        % T = TranslationModel([10 20]);
        % name = T.getParameterName(2);
        % name = 
        %   Y shift
        %
        
        % check index is not too high
        if paramIndex>length(this.params)
            error('Index greater than the number of parameters');
        end
        
        name = '';
        if paramIndex<=length(this.paramNames)
            name = this.paramNames{paramIndex};
        end
    end
    
    function name = getParameterNames(this)
        % Return the names of all parameters in a cell array of strings
        %
        % NAMES = Transfo.getParameterNames();
        % 
        % Example:
        % T = TranslationModel([10 20]);
        % names = T.getParameterNames()
        % ans = 
        %   'X shift'   'Y shift'
        %
        
        name = this.paramNames;
    end
end % methods

%% Abstract methods
methods (Abstract)
    getParametricJacobian(this, x, varargin)
    % Compute jacobian matrix, i.e. derivatives for each parameter
    
end % abstract methods 

end % classdef
