classdef CenteredTransformAbstract < Transform 
%CENTEREDTRANSFORMABSTRACT Add center management to a transform
%
%   This class is a skeleton to add the management of center to a trasnform
%   class. It is supposed to be derived to more specialized classes.
%
%   Example
%   CenteredTransformAbstract
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Properties
properties
    % The center of the transform. Initialized to (0,0,0).
    center = [0 0 0];
end

%% Constructor
methods
    % constructor
    function this = CenteredTransformAbstract(varargin)
        % Create a new centered transform
        % This constructor only initialize the center with the correct
        % dimension.
        %
        % Usage (in constructor if derived classes):
        % this = this@CenteredTransformAbstract(ND);
        % Initialize the center at the origin, with Nd dimensions.
        %
        % this = this@CenteredTransformAbstract(CENTER);
        % Initialize the center with the specified value.
        %
        
        if ~isempty(varargin)
            var = varargin{1};
            if length(var)==1
                this.center = zeros(1, var);
            else
                this.center = var;
            end
        end
    end % constructor
end

%% Methods
methods
    function setCenter(this, center)
        % Changes the center of rotation of the transform
        this.center = center;
    end
    
    function center = getCenter(this)
        % Returns the center of rotation of the transform
        center = this.center;
    end

end % methods

end % classdef
