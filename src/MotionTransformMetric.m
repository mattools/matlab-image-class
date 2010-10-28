classdef MotionTransformMetric < TransformMetric & ParametricFunction
%MOTIONTRANSFORMMETRIC Simple metric on motion transform
%
%   output = MotionTransformMetric(input)
%
%   Example
%   MotionTransformMetric
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Constructor
methods
    function this = MotionTransformMetric(varargin)
        % Initialize the metric with a transform.
        
        transfo = varargin{1};
        if ~isa(transfo, 'Transform')
            error('Input argument must be a transform');
        end
        
        this = this@TransformMetric(transfo);
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
            rotLog = sqrt(2)*abs(theta);
        elseif size(linearPart, 1)==3
            % compute rotation angle theta around the rotation axis (not computed)
            % valid only for 3D rotation matrices...
            theta = acos((trace(linearPart)-1)/2);
            rotLog = sqrt(2)*abs(theta);
        else
            error('dimension not managed');
        end
        
        transPart = mat(1:end-1, end);
        
        res = norm(transPart) + rotLog;
        
    end
    
end % methods implementing the 'ParametricFunction' interface

end % classdef
