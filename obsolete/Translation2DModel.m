classdef Translation2DModel < ParametricTransform & AffineTransform
%Transformation model for a translation defined by 2 parameters
%   output = Translation2DModel(input)
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


%% Declaration of class properties
properties
end

%% Constructors
methods
    function this = Translation2DModel(varargin)
        % Create a new model for translation transform model
        if isempty(varargin)
            % set parameters to default values
            this.params = [0 0];
        else
            % extract first argument, and try to interpret
            var = varargin{1};
            if isa(var, 'Translation2DModel')
                this.params = var.params;
            elseif isnumeric(var)
                this.params = var(1:2);
            else
                error('Unable to understand input arguments');
            end
        end
        
        
    end % constructor declaration
end

%% Standard methods
methods
    function mat = getAffineMatrix(this)
        % Returns the 3*3 affine matrix that represents this transform
        mat = [ ...
            1 0 this.params(1); ...
            0 1 this.params(2); ...
            0 0 1];
    end
    
    function jacobian = getParametricJacobian(this, x, varargin) %#ok<INUSD,MANU>
        % Compute jacobian matrix, i.e. derivatives for each parameter
        jacobian = [...
            1 0;
            0 1];
    end
    
end % methods


end % classdef