classdef CenteredMotionTransform2D < AffineTransform & ParametricTransform
%Transformation model for a centered rotation followed by a translation
%   
%   Inner optimisable parameters of the transform have the following form:
%   params[1] = theta, in degrees
%   params[2] = tx
%   params[3] = ty
% 
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-02-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Declaration of class properties
properties
    % Center of the transform. Initialized to (0,0).
    center = [0 0];
end

%% Constructors
methods
    function this = CenteredMotionTransform2D(varargin)
        % Create a new model for translation transform model
        if isempty(varargin)
            % parameters already set to default values
        else
            % extract first argument, and try to interpret
            var = varargin{1};
            if isa(var, 'CenteredMotionTransform2D')
                this.params = var.params;
            elseif isnumeric(var)
                if length(var)==1
                    this.params = [var 0 0];
                elseif length(var)==3
                    this.params = var(1:3);
                else
                    error('Please specify angle, or angle and vector');
                end
            else
                error('Unable to understand input arguments');
            end
        end
        
        % eventually parse additional arguments
        if nargin>2
            if strcmp(varargin{2}, 'center')
                % setup rotation center
                this.center = varargin{3};
            end
        end
        
        % setup parameter names
        this.paramNames = {'Theta (°)', 'X shift', 'Y shift'};
                
    end % constructor declaration
end

%% Standard methods
methods    
    function setCenter(this, center)
        % Changes the center of rotation of the transform
        this.center = center;
    end
    
    function center = getCenter(this)
        % Returns the center of rotation of the transform
        center = this.center;
    end
    
    function mat = getAffineMatrix(this)
        % Compute affine matrix associated with this transform
        
        % pre-computations
        theta = this.params(1)*pi/180;  % converts to radians
        cot = cos(theta);
        sit = sin(theta);

        % center coordinates
        cx = this.center(1);
        cy = this.center(2);

        % translation vector
        ux = this.params(2);
        uy = this.params(3);
        
        % build matrix
        mat = [...
        	cot -sit ( cx*(1-cot) + cy*sit     + ux) ; ...
        	sit +cot (-cx*sit     + cy*(1-cot) + uy) ; ...
            0 0 1 ];

    end
  
    function jacobian = getParametricJacobian(this, x, varargin)
        % Compute jacobian matrix, i.e. derivatives for each parameter
       
        % extract coordinate of input point(s)
        if isempty(varargin)
            y = x(:,2);
            x = x(:,1);
        else
            y = varargin{1};
        end
        
        theta = this.params(1)*pi/180;
        cot = cos(theta);
        sit = sin(theta);
        x = x - this.center(1);
        y = y - this.center(2);
        
        jacobian = [...
            (-sit*x - cot*y) 1 0 ;
            ( cot*x - sit*y) 0 1 ];
    end

end % methods


end % classdef