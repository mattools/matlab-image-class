classdef RegularizedImageToImageMetric < ParametricFunction
%REGULARIZEDIMAGETOIMAGEMETRIC  One-line description here, please.
%
%   output = RegularizedImageToImageMetric(input)
%
%   Example
%   RegularizedImageToImageMetric
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
    % an image to image metric
    metric;
    
    % the regularization object of the transform
    regul;
    
    % the transform itself
    transform;
    
    % the coefficient associated to the metric
    alpha;
    
    % the coefficient associated to the regularisation
    beta;
end
 
%% Constructor
methods
    function this = RegularizedImageToImageMetric(metric, regul, alpha, beta)
        this.metric = metric;
        this.regul  = regul;
        this.alpha  = alpha;
        this.beta   = beta;
        
    end % constructor
 
end % construction function
 
%% General methods
methods
    function setParameters(this, params)
        this.transform.setParameters(params);
    end
    
    function res = computeValue(this)
        res1 = this.alpha   * computeValue(this.metric);
        res2 = this.beta    * computeValue(this.regul);
        res  = res1 + res2;
    end
    
end % general methods
 
end % classdef

