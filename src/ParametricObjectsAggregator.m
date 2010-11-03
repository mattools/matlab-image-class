classdef ParametricObjectsAggregator < ParametricObject
%PARAMETERSDISPATCHER Concatenates several parametric objects into one
%
%   output = ParametricObjectsAggregator(input)
%
%   Example
%   ParametricObjectsAggregator
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Properties
properties
    % The set of inner parametric objects
    parametrics;
    
end
 
%% Constructor
methods
    function this = ParametricObjectsAggregator(varargin)
        % usage:
        % P = ParametricObjectsAggregator(PARAMETRICS);
        
        if nargin~=1
            error('Need one input argument');
        end
        
        var = varargin{1};
        if ~iscell(var)
            error('First argument must be a cell array of Parametric objects');
        end
        
        this.parametrics = var;
        
    end % constructor
    
end % construction function

%% Methods implementing the parametric Object interface
methods
    function params = getParameters(this)
        % Concatenate all parameters vectors into one
        
        nObj = length(this.parametrics);
        
        % compute the length of final parameter array
        nOP = getParameterLength(this);
        
        % concatenate all parameters
        params = zeros(1, nOP);
        ind = 0;
        for i=1:nObj
            param_i = getParameters(this.parametrics{i});
            nP = length(param_i);
            params(ind+(1:nP)) = param_i;
            ind = ind + nP;
        end
        
    end
    
    function setParameters(this, params)
        % Changes the parameter vector of the transform
        
        nObj = length(this.parametrics);
        
        % dispatch parameters to children
        ind = 0;
        for i=1:nObj
            item = this.parametrics{i};
            nP = getParameterLength(item);
            param_i = params(ind+(1:nP));
            item.setParameters(param_i);            
            ind = ind + nP;
        end
    end
    
    function nOP = getParameterLength(this)
        % Returns the total length of the parameter array
        
        nObj = length(this.parametrics);
        
        % compute the length of final parameter array
        nOP = 0;
        for i=1:nObj
            nOP = nOP + getParameterLength(this.parametrics{i});
        end
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
        
        % iterate over parametric objects
        nOP = 0;
        for i=1:nObj
            item = this.parametrics{i};
            nP = getParameterLength(item);
            
            if (nOP+nP) >= paramIndex
                name = item.getParameterName(paramIndex-nOP);
                break;
            end
            
            nOP = nOP + nP;
        end
    end
    
    function names = getParameterNames(this)
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

        nObj = length(this.parametrics);
        
        % iterate over parametric objects
        nOP = getParameterLength(this);
        
        % concatenate all parameter names
        names = cell(1, nOP);
        ind = 0;
        for i=1:nObj
            names_i = getParameterNames(this.parametrics{i});
            nP = length(names_i);
            names(ind+(1:nP)) = names_i;
            ind = ind + nP;
        end
     end
    
end % general methods
 

end
