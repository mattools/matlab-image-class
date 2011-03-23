classdef ComposedTransformModel < ParametricTransform
%ComposedTransformModel  Compose several parametric transforms
%   output = ComposedTransformModel(input)
%
%   Example
%   ParametricTransform2D
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-04-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    % the set of encapsulated transforms
    transforms;
end

%% Constructor
methods
    function this = ComposedTransformModel(varargin)
        % class constructor
        % T = ComposedTransformModel(T1, T2);
        
        if isa(varargin{1}, 'ComposedTransform') && nargin == 1
            % copy constructor
            var = varargin{1};
            this.transforms = var.transforms;
            
        elseif isa(varargin{1}, 'Transform')
            % initialize tranform array
            nbTrans = length(varargin);
            this.transforms = cell(nbTrans, 1);
            for i=1:nbTrans
                this.transforms{i} = varargin{i};
            end
            
        else
            error('Wrong parameter when constructing a Composed transform');
        end
        
        if ~isa(this.transforms{end}, 'ParametricTransform')
            error('Last transform must be a ParametricTransform');
        end
        
    end % constructor
end


%% Methods implementing Transform interface
methods
    function point = transformPoint(this, point)
        for i=1:length(this.transforms)
            point = this.transforms{i}.transformPoint(point);
        end
    end
    
    function vector = transformVector(this, vector, position)
        for i=1:length(this.transforms)
            vector = this.transforms{i}.transformVector(vector, position);
        end
    end
    
    function jacobian = getJacobian(this, point, varargin)
        % Compute jacobian matrix, i.e. derivatives for coordinate
        % jacob(i,j) = d x_i / d x_j
        jacobian = this.transforms{1}.getJacobian(point);
        for i=2:length(this.transforms)
            jacobian = this.transforms{i}.getJacobian(point, varargin{:}) * jacobian;
        end
    end
    
    function jacobian = getParametricJacobian(this, point, varargin)
        % Compute jacobian matrix, i.e. derivatives for coordinate
        % jacob(i,j) = d x_i / d x_j

        nTransfos = length(this.transforms);
        
        % first, transform points
        for i=1 : nTransfos-1
            point = this.transforms{i}.transformPoint(point, varargin{:});
        end

        % then, compute parametric jacobian of the last transform
        jacobian = this.transforms{end}.getParametricJacobian(point, varargin{:});
        
    end
end % methods


%% Overrides several methods from ParametricTransform 

% The goal is to to manipulate params of the last transform instead of
% local parameters

methods
    function p = getParameters(this)
        % Returns the parameter vector of the transform
        p = this.transforms{end}.params;
    end
    
    function setParameters(this, params)
        % Changes the parameter vector of the transform
        this.transforms{end}.params = params;
    end
    
    function Np = getParameterLength(this)
        % Returns the length of the vector parameter
        Np = length(this.transforms{end}.params);
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
        if paramIndex > length(this.transforms{end}.params)
            error('Index greater than the number of parameters');
        end
        
        % return a parameter name if it was initialized
        name = '';
        if paramIndex <= length(this.transforms{end}.paramNames)
            name = this.transforms{end}.paramNames{paramIndex};
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
        
        name = this.transforms{end}.paramNames;
    end
end % overridden methods

end % classdef
