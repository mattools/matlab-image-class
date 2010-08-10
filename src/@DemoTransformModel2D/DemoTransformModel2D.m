classdef DemoTransformModel2D < handle
%DEMOTRANSFORMMODEL2D  One-line description here, please.
%   output = DemoTransformModel2D(input)
%
%   Example
%   DemoTransformModel2D
%
%   See also
%
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
    % Translation is performed after the rotation.
    params = [0 0 0];
end

%% Constructors
methods
    function this = DemoTransformModel2D(varargin)
        % Create a new model for rigid transform
        
        % parameters already set to default values
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
    
    function varargout = transformPoint(this, x, varargin)
        % extract coordinate of input point(s)
        if isempty(varargin)
            y = x(:,2);
            x = x(:,1);
        else
            y = varargin{1};
        end
        
        cot = cos(this.params(3));
        sit = sin(this.params(3));
        
        xt = cot*x - sit*y + this.params(1);
        yt = sit*x + cot*y + this.params(2);
            
        if nargout==1
            varargout{1} = [xt(:) yt(:)];
        else
            varargout{1} = xt;
            varargout{2} = yt;
        end        
    end
    
    function jacobian = getJacobian(this, x, varargin)
        % extract coordinate of input point(s)
        
        %TODO: choose name for:
        %   + Jacobian with respect to coordinates (2*2)
        %   + Jacobian with respect to parameters (2*Np)
        if isempty(varargin)
            y = x(:,2);
            x = x(:,1);
        else
            y = varargin{1};
        end
        
        cot = cos(this.params(1));
        sit = sin(this.params(1));
        
        jacobian = [...
            1 0 -sit*x-cot*y;
            0 1  cot*x-sit*y];
    end

end % methods


end % classdef