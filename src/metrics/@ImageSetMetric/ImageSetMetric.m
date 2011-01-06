classdef ImageSetMetric < handle
%IMAGESETMETRIC  One-line description here, please.
%
%   METRIC = ImageSetMetric(IMAGES, POINTS);
%   IMAGES: a cell array containing image functions (image interpolators,
%       or instances of BackwardTransformedImage)
%   POINTS: a N-by-2 or N-by3 array containing coordinates of test points
%
%   Example
%   ImageSetMetric
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-09-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Properties
properties
    % the set of images
    images;
    
    % the set of points that will be used for evaluating the metric
    points;
    
end % properties

%% Constructor
methods (Access = protected)
    
    function this = ImageSetMetric(varargin)
        % Protected constructor of ImageSetMetric class
        errorID = 'ImageSetMetric:Constructor';
        
        if nargin==2
            % Inputs are the set of images, and the array of points
            this.images = varargin{1};
            this.points = varargin{2};
            
        else
            error(errorID, 'Need at least 2 inputs');
        end
        
        ensureImagesValidity(this);
        
    end % constructor
    
end % methods

%% Private methods
methods (Access=private)
    
    function ensureImagesValidity(this)
        % Checks that images are instances of ImageFunction, otherwise
        % create appropriate interpolators
        for i=1:length(this.images)
            img = this.images{i};
            
            % input image should be an image function
            if isa(img, 'ImageFunction')
                continue;
            end
            
            % Try to create an appropriate image function
            if isa(img, 'Image')
                img = ImageInterpolator.create(img, 'linear');
            elseif isnumeric(img)
                img = Image.create(img);
                img = ImageInterpolator.create(img, 'linear');
            else
                error('Unknown image data');
            end
            this.images{i} = img;
            
        end
    end
end

%% Abstract methods
methods (Abstract)
    computeValue(this)
    % Evaluate the difference between the images
end

end