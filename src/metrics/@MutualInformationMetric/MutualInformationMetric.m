classdef MutualInformationMetric < ImageToImageMetric
%MutualInformationMetric Compute minus the mutual information of two images
%
%   output = MutualInformationMetric(input)
%
%   Example
%   METRIC = MutualInformationMetric(IMG1, IMG2, POINTS);
%   METRIC.computeValue()
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Constructor
methods
    function this = MutualInformationMetric(varargin)
        % calls the parent constructor
        this = this@ImageToImageMetric(varargin{:});
        
    end % constructor
    
end % methods

end % classdef
