classdef CenteredTransformAbstract < Transform 
%CENTEREDTRANSFORMABSTRACT Add center management to a transform
%
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
    % Center of the transform. Initialized to (0,0,0).
    center = [0 0 0];
end

%% Constructor
methods
    % constructor
    function this = CenteredQuadTransformModel3D(varargin)
        % Create a new centered transform
        % This constructor only initialize the center with correct
        % dimension.
        if ~isempty(varargin)
            nd = varargin{1};
            this.center = zeros(1, nd);
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
