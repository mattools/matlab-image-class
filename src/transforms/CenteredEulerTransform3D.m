classdef CenteredEulerTransform3D < AffineTransform & ParametricTransform
%Transformation model for a centered rotation followed by a translation
%   
%   Inner optimisable parameters of the transform have the following form:
%   params[1] = phi, rotation angle around Ox, in degrees
%   params[2] = theta, rotation angle around Oy, in degrees
%   params[3] = psi, rotation angle around Oz, in degrees
%   params[4] = tx
%   params[5] = ty
%   params[6] = tz
% 
%   Creation:
%   Trans = CenteredEulerTransform3D();
%   
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Declaration of class properties
properties
    % Center of the transform. Initialized to (0,0,0).
    center = [0 0 0];
end

%% Constructors
methods
    function this = CenteredEulerTransform3D(varargin)
        % Create a new centered motion transform
        
        this.params = zeros(1, 6);
        
        if ~isempty(varargin)
            % extract first argument, and try to interpret
            var = varargin{1};
            if isa(var, 'CenteredEulerTransform3D')
                % copy constructor
                this.params = var.params;
                
            elseif isnumeric(var)
                len = length(var);
                if len==6
                    % all parameters are specified
                    this.params = var;
                elseif len==3
                    % specify only angles, initialize translation to 0
                    this.params = [var 0 0 0];
                elseif len==1
                    % give the possibility to call constructor with the
                    % dimension of image
                    if var~=3
                        error('Defined only for 3 dimensions');
                    end
                else
                    error('Please specify 3 angles and a 3D vector');
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
        this.paramNames = {...
            'Phi (°)', 'Theta (°)', 'Psi (°)', ...
            'X shift', 'Y shift', 'Z shift'};
                
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
    
    function initFromTranslation(this, vector)
        % Initialize parameters from a translation vector
        %
        % Example
        % T = CenteredEulerTransform3D();
        % T.initFromTranslation([10 15 20]);
        % T.getParameters()
        % ans = 
        %     [0 0 0 10 15 20]
        %
        this.parameters = [0 0 0 vector];
    end
    
    function mat = getAffineMatrix(this)
        % Compute affine matrix associated with this transform
        
        % extract angles and convert to radians
        phi     = this.params(1)*pi/180;
        theta   = this.params(2)*pi/180;
        psi     = this.params(3)*pi/180;

        % compute elementary rotation matrices
        Rx = createRotationOx(phi);
        Ry = createRotationOy(theta);
        Rz = createRotationOz(psi);
        
        % compute compound rotation matrix around center
        mat = recenterTransform3d(Rz*Ry*Rx, this.center);
        
        % add translation
        mat = createTranslation3d(this.params(4:6))*mat;
        
    end
  
    function jacobian = getParametricJacobian(this, x, varargin)
        % Compute jacobian matrix, i.e. derivatives for each parameter
       
        % extract coordinate of input point(s)
        if isempty(varargin)
            y = x(:,2);
            z = x(:,3);
            x = x(:,1);
        else
            y = varargin{1};
            z = varargin{2};
        end
        
        % extract angles, and convert to radians
        phi     = this.params(1)*pi/180;
        theta   = this.params(2)*pi/180;
        psi     = this.params(3)*pi/180;

        % pre-computations of trigonometric functions
        cx = cos(phi);      sx = sin(phi);
        cy = cos(theta);    sy = sin(theta);
        cz = cos(psi);      sz = sin(psi);

        % jacobians are computed with respect to transformation center
        x = x - this.center(1);
        y = y - this.center(2);
        z = z - this.center(3);
        
        % compute the Jacobian matrix using pre-computed elements
        jacobian = [[...
            ((cz*sy*cx + sz*sx)*y + (sz*cx - cz*sy*sx)*z), ...
            ((sz*sy*cx - cz*sx)*y - (sz*sy*sx + cz*cx)*z), ...
            (             cy*cx*y -              cy*sx*z); ...
            ...
            (-cz*sy*x + cz*cy*sx*y + cz*cy*cx*z), ...
            (-sz*sy*x + sz*cy*sx*y + sz*cy*cx*z), ...
            (-cy*x    -    sy*sx*y -    sy*cx*z); ...
            ...
            (-sz*cy*x - (sz*sy*sx + cz*cx)*y + (cz*sx - sz*sy*cx)*z), ...
            ( cz*cy*x + (cz*sy*sx - sz*cx)*y + (cz*sy*cx + sz*sx)*z), ...
            0; ...
            ]' ...
            eye(3, 3)]; % correspond to translation part of the transform
    end

end % methods


end % classdef