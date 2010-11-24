classdef MeanSquaredDifferencesRegistrationMetric < RegisteredImageMetric
%MEANSQUAREDDIFFERENCESREGISTRATIONMETRIC  One-line description here, please.
%
%   output = MeanSquaredDifferencesRegistrationMetric(input)
%
%   Example
%   MeanSquaredDifferencesRegistrationMetric
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
    % The gradient image
    gradientImage;
end
 
%% Constructor
methods
    function this = MeanSquaredDifferencesRegistrationMetric(varargin)
        
        grad = [];
        if nargin==5
            inputs = varargin([1:3 5]);
            grad = varargin{4};
        else
            inputs = varargin;
        end
        
        this = this@RegisteredImageMetric(inputs{:});
        this.gradientImage = grad;
        
    end % constructor
 
end % construction function

%% Some general usage methods
methods
    function transform = getTransform(this)
        transform = this.transform;
    end
    
    function setTransform(this, transform)
        this.transform = transform;
        % build the backward transformed image
        this.transformedImage = BackwardTransformedImage(...
            this.movingImage, this.transform);
    end
    
    function gradient = getGradientImage(this)
        gradient = this.gradientImage;
    end
    
    function setGradientImage(this, gradient)
        this.gradientImage = gradient ;
    end 
        
end

end % classdef
