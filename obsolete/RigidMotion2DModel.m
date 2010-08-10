classdef RigidMotion2DModel < ParametricTransform & AffineTransform
%Transformation model for a rotation followed by a translation
%   output = RigidMotion2DModel(input)
%
%   inner optimisable parameters of the transform have following form:
%   params(1): tx       (in user spatial unit)
%   params(2): ty       (in user spatial unit)
%   params(3): theta    (in degrees)
%
%   They are initialised by default as:
%   params = [0 0 0];
%   
%   Example
%   RigidMotion2DModel
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-02-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Constructors
methods
    function this = RigidMotion2DModel(varargin)
        % Create a new model for translation transform model
        if isempty(varargin)
            % parameters already set to default values
        else
            % extract first argument, and try to interpret
            var = varargin{1};
            if isa(var, 'RigidMotion2DModel')
                this.params = var.params;
            elseif isnumeric(var)
                this.params = var(1:3);
            else
                error('Unable to understand input arguments');
            end
        end
        
        % setup parameter names
        this.paramNames = {'Theta (°)', 'X shift', 'Y shift'};
        
    end % constructor declaration
end

%% Standard methods
methods    
    function jacobian = getParametricJacobian(this, x, varargin)
        % Compute jacobian matrix, i.e. derivatives for each parameter
        
        % extract coordinate of input point(s)
        if isempty(varargin)
            y = x(:,2);
            x = x(:,1);
        else
            y = varargin{1};
        end
        
        theta = this.params(3)*pi/180;
        cot = cos(theta);
        sit = sin(theta);
        jacobian = [...
            1 0 -sit*x-cot*y;
            0 1 cot*x-sit*y];
    end
    
    function mat = getAffineMatrix(this)
        % Returns the 3*3 affine matrix that represents this transform
        theta = this.params(3)*pi/180;
        cot = cos(theta);
        sit = sin(theta);

        mat = [ ...
            cot -sit this.params(1); ...
            sit  cot this.params(2); ...
            0 0 1];
    end
    
end % methods

end % classdef