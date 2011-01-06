classdef SumOfMeanSquaredDifferences < CostFunction
%SUMOFMEANSQUAREDDIFFERENCES Compute the sum of MSD on each image couples
%
%   Quite similar to class "SumOfSSDImageSetMetric", but this class is
%   intended to provide computation of Gradient with respect to parameters.
%
%   output = SumOfMeanSquaredDifferences(input)
%
%   Example
%   SumOfMeanSquaredDifferences
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-01-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%% Properties
properties
    % First, some "public" data.
    
    % the set of images to transform
    images;
    
    % the set of test points in reference space
    points;
    
    % the set of parametric transforms
    transforms;
    
    % the set of gradient image. Either as a set of Vector Images, or as a
    % set of Gradient evaluators
    gradients;
    
    % Then, some private data used during computation
    
    % images after transforms
    transformedImages;
    
    % gradient images after transforms
    transformedGradients
    
end 

%% Constructor
methods
    function this = SumOfMeanSquaredDifferences(images, points, transforms, varargin)
        % Construct a new image set metric
        %
        % Metric = SumOfMeanSquaredDifferences(IMGS, PTS, TRANSFOS);
        % Metric = SumOfMeanSquaredDifferences(IMGS, PTS, TRANSFOS, GRADS);
        %
        
        errorID = 'SumOfMeanSquaredDifferences:Constructor';
        
        if nargin>=3
            % Inputs are the set of images, the array of points, and the
            % set of transforms
            this.images     = images;
            this.points     = points;
            this.transforms = transforms;
        else
            error(errorID, 'Need at least 3 inputs');
        end
        
        % Gradients can be specified
        if nargin>3
            this.gradients = varargin{1};
        else
            error('Not yet implemented');
            %TODO: create gradients or gradient interpolators
        end
        
        ensureImagesValidity(this);
        createTransformedImages(this);

        ensureGradientsValidity(this);
        createTransformedGradients(this);
        
    end % constructor 

end % construction function

%% General methods
methods (Access = protected)

    function ensureImagesValidity(this)
        % Checks that images are instances of ImageFunction, otherwise
        % creates appropriate interpolators
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
    
    function createTransformedImages(this)
        % Creates instances of transformed images
        
        % small check
        nImg = length(this.images);        
        if length(this.transforms) ~= nImg
            error('Number of transforms should equal number of images');
        end
        
        % create array
        this.transformedImages = cell(1, nImg);
        
        % iterate over image-transform couple to create transformed images
        for i=1:nImg
            image = this.images{i};
            transfo = this.transforms{i};
            tim = BackwardTransformedImage(image, transfo);
            this.transformedImages{i} = tim;
        end
    end
    
    function ensureGradientsValidity(this)
        % Checks that gradient images are instances of ImageFunction, 
        % otherwise creates appropriate interpolators
        for i=1:length(this.gradients)
            gradImg = this.gradients{i};
            
            % input image should be an image function
            if isa(gradImg, 'ImageFunction')
                continue;
            end
            
            % Try to create an appropriate image function
            if isa(gradImg, 'Image')
                gradImg = ImageInterpolator.create(gradImg, 'nearest');
            else
                error('Unknown image data');
            end
            this.gradients{i} = gradImg;
            
        end
    end
    
    function createTransformedGradients(this)
        % Creates instances of transformed gradient images or functions
        
        % small check
        nImg = length(this.gradients);        
        if length(this.transforms) ~= nImg
            error('Number of transforms should equal number of gradient images');
        end
        
        % create array
        this.transformedGradients = cell(1, nImg);
        
        % iterate over image-transform couple to create transformed images
        for i=1:nImg
            image = this.gradients{i};
            transfo = this.transforms{i};
            tim = BackwardTransformedImage(image, transfo);
            this.transformedGradients{i} = tim;
        end
    end
    
end % abstract methods

end % classdef
