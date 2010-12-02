classdef CenteredQuadTransformModel3D < CenteredTransformAbstract & ParametricTransform
%CenteredQuadTransformModel3D  One-line description here, please.
%
%   output = CenteredQuadTransformModel3D(input)
%
%   Example
%   CenteredQuadTransformModel3D
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Constructors
methods
    function this = CenteredQuadTransformModel3D(varargin)
        % Create a new centered affine transform model
        
        this.params = [ ...
            0 0 0 ...   % constant terms for x', y', and z'
            1 0 0 ...   % x coef 
            0 1 0 ...   % y coef 
            0 0 1 ...   % z coef 
            0 0 0 ...   % x^2 coef
            0 0 0 ...   % y^2 coef
            0 0 0 ...   % z^2 coef
            0 0 0 ...   % x*y coef
            0 0 0 ...   % x*z coef
            0 0 0 ...   % y*z coef
            ];
        
        if ~isempty(varargin)
            % extract first argument, and try to interpret
            var = varargin{1};
            if isa(var, 'CenteredQuadTransformModel3D')
                % copy constructor
                this.params = var.params;
                
            elseif isnumeric(var)
                len = length(var);
                if len==30
                    % all parameters are specified as a row vector
                    this.params = var;
                    
%                 elseif sum(size(var)~=[4 4])==0 || sum(size(var)~=[3 4])==0
%                     % the parameter matrix is specified
%                     var = var(1:3, :)';
%                     this.params = var(:)';
                    
                elseif len==1
                    % give the possibility to call constructor with the
                    % dimension of image
                    % Initialize with identity transform
                    if var~=3
                        error('Defined only for 3 dimensions');
                    end
                    
                else
                    error('Please specify affine parameters');
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
            'x_w2', 'y_w2','z_w2', ...  % constant terms for x', y', and z'
            'x_wx', 'y_wx','z_wx', ...  % x coef
            'x_wy', 'y_wy','z_wy', ...  % y coef
            'x_wz', 'y_wz','z_wz', ...  % z coef
            'x_x2', 'y_x2','z_x2', ...  % x^2 coef
            'x_y2', 'y_y2','z_y2', ...  % y^2 coef
            'x_z2', 'y_z2','z_z2', ...  % z^2 coef
            'x_xy', 'y_xy','z_xy', ...  % x*y coef
            'x_xz', 'y_xz','z_xz', ...  % x*z coef
            'x_yz', 'y_yz','z_yz', ...  % x*z coef
            };
    end     
    
end

%% Methods specific to this class
methods    
    function initFromAffineTransform(this, transform)
        % Initialize parameters from an affine transform (class or matrix)
        %
        % Example
        % T = CenteredAffineTransformModel3D();
        % mat = createEulerAnglesRotation(.1, .2, .3);
        % T.initFromAffineTransform(mat);
        % T.getParameters()
        %
        
        % if the first argument is a Transform, extract its affine matrix
        if isa(transform, 'AffineTransform')
            transform = getAffineMatrix(transform);
        end
        
        % format matrix to have a row vector of 12 elements
        this.params = [...
            transform(1:3, 4)' ...
            transform(1:3, 1)' ...
            transform(1:3, 2)' ...
            transform(1:3, 3)' ...
            zeros(1, 18) ...
            ];
    end

end


%% Implementation of methods inherited from Transform
methods
    function point2 = transformPoint(this, point)
        % TRANSFORMPOINT Computes coordinates of transformed point
        % PT2 = this.transformPoint(PT);
        
        % compute centered coords.
        x = point(:, 1) - this.center(1);
        y = point(:, 2) - this.center(2);
        z = point(:, 3) - this.center(3);
        
        % init with translation part
        x2 = ones(size(x)) * this.params(1);
        y2 = ones(size(x)) * this.params(2);
        z2 = ones(size(x)) * this.params(3);
        
        % add linear contributions
        x2 = x2 + x * this.params(4);
        y2 = y2 + x * this.params(5);
        z2 = z2 + x * this.params(6);
        x2 = x2 + y * this.params(7);
        y2 = y2 + y * this.params(8);
        z2 = z2 + y * this.params(9);
        x2 = x2 + z * this.params(10);
        y2 = y2 + z * this.params(11);
        z2 = z2 + z * this.params(12);

        % add quadratic contributions
        x2 = x2 + x.^2 * this.params(13);
        y2 = y2 + x.^2 * this.params(14);
        z2 = z2 + x.^2 * this.params(15);
        x2 = x2 + y.^2 * this.params(16);
        y2 = y2 + y.^2 * this.params(17);
        z2 = z2 + y.^2 * this.params(18);
        x2 = x2 + z.^2 * this.params(19);
        y2 = y2 + z.^2 * this.params(20);
        z2 = z2 + z.^2 * this.params(21);

        % add product contributions
        x2 = x2 + x.*y * this.params(22);
        y2 = y2 + x.*y * this.params(23);
        z2 = z2 + x.*y * this.params(24);
        x2 = x2 + x.*z * this.params(25);
        y2 = y2 + x.*z * this.params(26);
        z2 = z2 + x.*z * this.params(27);
        x2 = x2 + y.*z * this.params(28);
        y2 = y2 + y.*z * this.params(29);
        z2 = z2 + y.*z * this.params(30);

        % recenter points
        x2 = x2 + this.center(1);
        y2 = y2 + this.center(2);
        z2 = z2 + this.center(3);

        % concatenate coordinates
        point2 = [x2 y2 z2];
    end
    
    function vect2 = transformVector(this, vector, position)
        % TRANSFORMVECTOR Computes coordinates of transformed vector
        % VEC2 = this.transformPoint(VEC, PT);
        % TODO: to be done later
        error('Not yet implemented');
    end
    
    function jacobian = getJacobian(this, point)
        % Computes jacobian matrix, i.e. derivatives wrt to each coordinate
        % jacob(i,j) = d x_i / d x_j
        
        % compute centered coords.
        x = point(:, 1) - this.center(1);
        y = point(:, 2) - this.center(2);
        z = point(:, 3) - this.center(3);
 
        p = this.params;
        dxx = p(4)  + 2*x*p(13) + y*p(22) + z*p(25);
        dyx = p(5)  + 2*x*p(14) + y*p(23) + z*p(26);
        dzx = p(6)  + 2*x*p(15) + y*p(24) + z*p(27);
        
        dxy = p(7)  + 2*y*p(16) + x*p(22) + z*p(28);
        dyy = p(8)  + 2*y*p(17) + x*p(23) + z*p(29);
        dzy = p(9)  + 2*y*p(18) + x*p(24) + z*p(30);
        
        dxz = p(10) + 2*y*p(19) + x*p(25) + y*p(28);
        dyz = p(11) + 2*y*p(20) + x*p(26) + y*p(29);
        dzz = p(12) + 2*y*p(21) + x*p(27) + y*p(30);
        
        jacobian = [dxx dxy dxz ; dyx dyy dyz ; dzx dzy dzz];
    end
    
end % Transform methods 

%% Implementation of methods inherited from ParametricTransform
methods
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
        
        % jacobians are computed with respect to transformation center
        x = x - this.center(1);
        y = y - this.center(2);
        z = z - this.center(3);
        
        % compute the Jacobian matrix using pre-computed elements
        jacobian = [...
            1 1 1 ...
            x x x ...
            y y y ...
            z z z ...
            x.^2 x.^2 x.^2 ...
            y.^2 y.^2 y.^2 ...
            z.^2 z.^2 z.^2 ...
            x.*y x.*y x.*y ...
            x.*z x.*z x.*z ...
            y.*z y.*z y.*z ...
            ];
    end
    
end % parametric transform methods 

end
