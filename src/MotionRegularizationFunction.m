classdef MotionRegularizationFunction < TransformRegularizationFunction
%MOTIONREGULARIZATIONFUNCTION  One-line description here, please.
%
%   output = MotionRegularizationFunction(input)
%
%   Example
%   MotionRegularizationFunction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Constructor
methods
    function this = MotionRegularizationFunction(varargin)
        % Initialize the metric with a transform.

        transfo = varargin{1};
        if ~isa(transfo, 'Transform')
            error('Input argument must be a transform');
        end

        this = this@TransformRegularizationFunction(transfo);
    end
end % constructor


methods
    function setParameters(this, params)
        this.transform.setParameters(params);
    end
end

methods
    function res = computeValue(this)

        transfo = this.transform;
        if ~isa(transfo, 'AffineTransform')
            error('Sorry, requires a motion transform as input');
        end

        mat = transfo.getAffineMatrix();

        linearPart = mat(1:end-1, 1:end-1);

        if size(linearPart, 2)==2
            theta = atan2(mat(2,1), mat(1,1));

        elseif size(linearPart, 1)==3
            % compute rotation angle theta around the rotation axis
            % (the rotation axis is not computed)
            % valid only for 3D rotation matrices...
            theta = acos((trace(linearPart) - 1) / 2);

        else
            error('Dimension not managed');
        end

        rotLog = 2*theta^2;

        transPart = mat(1:end-1, end);

        res = sum(transPart.^2) + rotLog;

    end

end % methods implementing the 'ParametricFunction' interface
    
end % classdef
