classdef TransformRegularizationFunction < BaseFunction
%TRANSFORMREGULARIZATIONFUNCTION  One-line description here, please.
%
%   output = TransformRegularizationFunction(input)
%
%   Example
%   TransformRegularizationFunction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    transform
end

%% Constructor
methods (Access = protected)
    function this = TransformRegularizationFunction(varargin)
        % Initialize the regularization function with the transform.

        transfo = varargin{1};
        if ~isa(transfo, 'Transform')
            error('Input argument must be an instance of Transform class');
        end
        
        this.transform = transfo;

    end
end % constructor

end
