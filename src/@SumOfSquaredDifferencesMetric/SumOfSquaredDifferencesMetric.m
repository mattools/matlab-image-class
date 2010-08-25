classdef SumOfSquaredDifferencesMetric < ImageToImageMetric
%SumOfSquaredDifferencesMetric Compute sum of squared differences metric
%
%   output = SumOfSquaredDifferencesMetric(input)
%
%   Example
%   SumOfSquaredDifferencesMetric
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
    function this = SumOfSquaredDifferencesMetric(varargin)
        % calls the parent constructor
        this = this@ImageToImageMetric(varargin{:});
        
    end % constructor
    
end % methods

end % classdef
