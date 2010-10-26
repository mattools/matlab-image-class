classdef MeanSquaredDifferencesMetric < ImageToImageMetric
%Image to Image metric that compute mean of squared differences 
%
%   METRIC = MeanSquaredDifferencesMetric(IMG1, IMG2, POINTS)
%   IMG1 and IMG2 are preferentially instances of BackwardTransformedImage,
%   POINTS is a set of ND points stored in NP-by-ND array of double.
%
%   Example
%   MeanSquaredDifferencesMetric
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Some properties specific to the MSD metric
properties
    % the transform model (necessary to compute the metric gradient)
    transform;
    
    % The gradient image
    gradientImage;
end

%% Constructor
methods
    function this = MeanSquaredDifferencesMetric(varargin)
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
