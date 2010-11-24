classdef TransformMetric < handle
%TRANSFORMMETRIC Class that compute regularization on a transform
%
%   output = TransformMetric(input)
%
%   Example
%   TransformMetric
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Properties
properties
    transform;
end

%% Constructor
methods
    function this = TransformMetric(varargin)
        % Initialize the metric with a transform.
        
        if ~isempty(varargin)
            this.transform = varargin{1};
        end
    end
end % constructor


%% Abstract methods
methods (Abstract)
    value = computeValue(this);
    
end % abstract methods

end % classdef
