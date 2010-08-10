classdef CenteredRigidMotion2DModel < handle
%Transformation model for a centered rotation followed by a translation
%   
%   rotation angle is specifed in degrees.
%
%   Example
%   CenteredRigidMotion2DModel
%
%   See also
%   CenteredMotionTransform
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-02-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Declaration of class properties
properties
    % inner optimisable parameters of the transform
    % params[1] = tx
    % params[2] = ty
    % params[3] = theta
    params = [0 0 0];
    
    % center of the transform
    center = [0 0];
end

%% Constructors
methods
    function this = CenteredRigidMotion2DModel(varargin)
        % Create a new model for translation transform model
        if isempty(varargin)
            % parameters already set to default values
        else
            % extract first argument, and try to interpret
            var = varargin{1};
            if isa(var, 'CenteredRigidMotion2DModel')
                this.params = var.params;
            elseif isnumeric(var)
                this.params = var(1:3);
            else
                error('Unable to understand input arguments');
            end
        end
        
        
    end % constructor declaration
end

%% Standard methods
methods
    function params = getParameters(this)
        params = this.params;  
    end
    
    function setParameters(this, params)
        this.params = params;  
    end
    
    function setCenter(this, center)
        this.center = center;
    end
    
    function center = getCenter(this)
        center = this.center;
    end
    
    function varargout = transformPoint(this, x, varargin)
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
        xc = this.center(1);
        yc = this.center(2);
        
        xt = (x-xc)*cot - (y-yc)*sit + xc + this.params(1);
        yt = (x-xc)*sit + (y-yc)*cot + yc + this.params(2);
            
        if nargout==1
            varargout{1} = [xt(:) yt(:)];
        else
            varargout{1} = xt;
            varargout{2} = yt;
        end        
    end
    
    function jacobian = getJacobian(this, x, varargin)
        % Compute jacobian matrix, i.e. derivatives for each parameter
        
        %TODO: choose name for:
        %   + Jacobian with respect to coordinates (2*2)
        %   + Jacobian with respect to parameters (2*Np)
       
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
        xc = this.center(1);
        yc = this.center(2);
        
        jacobian = [...
            1 0 -sit*(x-xc)-cot*(y-yc);
            0 1 cot*(x-xc)-sit*(y-yc)];
    end

end % methods


end % classdef