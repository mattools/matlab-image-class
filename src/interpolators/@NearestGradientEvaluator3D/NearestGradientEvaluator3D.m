classdef NearestGradientEvaluator3D < ImageFunction
%NEARESTGRADIENTEVALUATOR3D  One-line description here, please.
%
%   output = NearestGradientEvaluator3D(input)
%
%   Example
%   NearestGradientEvaluator3D
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    refImage;
end

%% Constructors
methods
    function this = NearestGradientEvaluator3D(varargin)
        if nargin>0
            var = varargin{1};
            if isa(var, 'NearestGradientEvaluator3D')
                this.refImage = var.refImage;
            elseif isa(var, 'Image')
                this.refImage = var;
            end
        end
    end
end

end