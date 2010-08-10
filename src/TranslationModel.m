classdef TranslationModel < ParametricTransform & AffineTransform
%Transformation model for a translation defined by ND parameters
%   output = TranslationModel(input)
%
%   Parameters of the transform:
%   inner optimisable parameters of the transform have following form:
%   params(1): tx       (in user spatial unit)
%   params(2): ty       (in user spatial unit)
%
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-02-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Constructors
methods
    function this = TranslationModel(varargin)
        % Create a new model for translation transform model
        if isempty(varargin)
            % set parameters to default translation in 2D
            this.params = [0 0];
        else
            % extract first argument, and try to interpret
            var = varargin{1};
            if isa(var, 'TranslationModel')
                this.params = var.params;
            elseif isnumeric(var)
                this.params = var;
            else
                error('Unable to understand input arguments');
            end
        end
        
        % update parameter names
        np = length(this.params);
        switch np
            case 2
                this.paramNames = {'X shift', 'Y shift'};
            case 3
                this.paramNames = {'X shift', 'Y shift', 'Z shift'};
            otherwise
                this.paramNames = cellstr(num2str((1:4)', 'Shift %d'));
        end
        
    end % constructor declaration
end

%% Standard methods
methods
    function mat = getAffineMatrix(this)
        % Returns the affine matrix that represents this transform
        nd = length(this.params);
        mat = eye(nd+1);
        mat(1:end-1, end) = this.params(:);
    end
    
    function jac = getParametricJacobian(this, x, varargin) %#ok<INUSD>
        % Compute jacobian matrix, i.e. derivatives for each parameter
        nd = length(this.params);
        jac = eye(nd);
    end
    
end % methods

end % classdef