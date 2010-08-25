classdef ImageToImageRegistration < handle
% Base class for implementing more specialized registration algorithms
%
%   Example
%   ImageToImageRegistration
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Protected properties, shared by subclasses
properties (Access = protected)
    % the (eventually interpolated) fixed image
    img1;
    
    % the (eventually interpolated) moving image
    img2;
    
    % the transformation model, that map coordinates from img1 basis to
    % img2 basis
    transfo;
    
    % the transformed moving image (instance of ImageFunction)
    tmi;
    
    % set of test points
    points;
       
    % image to image metric
    metric;
    
    % set of parameters
    params;
    
    % scaling factor associated to each parameter. 
    paramScales;
    
    % output function, called at the end of ach iteration
    outputFunction = [];
    
end % properties

%% Constructors
methods
    
    function this = ImageToImageRegistration(varargin)
    end
    
end % methods

%% protected methods
methods (Access = protected)
    
    function initializeSSDMetric(this)
        % Create a new SSD Image to image metric
        this.metric = SumOfSquaredDifferencesMetric(...
            this.img1, this.tmi, this.points);
    end
    
end % protected methods

end