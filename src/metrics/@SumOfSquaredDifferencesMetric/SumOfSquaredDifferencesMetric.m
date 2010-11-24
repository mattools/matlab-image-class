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

%% Some properties specific to the SSD metric
properties
    % the transform model (necessary to compute the metric gradient)
    transform;
    
    % The gradient image
    gradientImage;
end

%% Constructor
methods
    function this = SumOfSquaredDifferencesMetric(varargin)
        % calls the parent constructor
        this = this@ImageToImageMetric(varargin{:});
        
    end % constructor
    
end % methods

%% Accessors and modifiers
methods
    function transform = getTransform(this)
        transform = this.transform;
    end
    
    function setTransform(this, transform)
        this.transform = transform;
    end
    
    function gradient = getGradientImage(this)
        gradient = this.gradientImage;
    end
    
    function setGradientImage(this, gradient)
        this.gradientImage = gradient ;
    end 
        
end % methods

end % classdef
