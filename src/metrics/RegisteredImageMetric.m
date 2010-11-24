classdef RegisteredImageMetric < handle
%REGISTEREDIMAGEMETRIC  One-line description here, please.
%
%   output = RegisteredImageMetric(input)
%
%   Example
%   RegisteredImageMetric
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
    % the reference image (interpolated)
    fixedImage;

    % the moving image (interpolated)
    movingImage;

    % the transform model from fixed image to moving image
    transform;

    % the set of points used for metric evaluation
    points;

    % the transformed image
    transformedImage;
end

%% Constructor
methods (Access = protected)
    function this = RegisteredImageMetric(img1, img2, transfo, points)
        
        % check inputs
        if nargin<3
            error('Need to specify some input arguments...');
        end
        
        % process fixed image
        if isa(img1, 'ImageFunction')
            this.fixedImage = img1;
        else
            this.fixedImage = ImageInterpolator.create(img1, 'linear');
        end
        
        % process moving image
        if isa(img2, 'ImageFunction')
            this.movingImage = img2;
        else
            this.movingImage = ImageInterpolator.create(img2, 'linear');
        end
        
        % in the case of 3 arguments, the third one is the number of points
        if nargin==3
            this.points = transfo;
            % create an identify transform
            nd = img1.getDimension();
            this.transform = TranslationModel(nd);
            
        else
            % process transform
            if ~isa(transfo, 'ParametricTransform')
                error('Transform should be parametric');
            end
            this.transform = transfo;
            
            % stores the set of test points
            this.points = points;
        end
        
        % build the backward transformed image
        this.transformedImage = BackwardTransformedImage(...
            this.movingImage, this.transform);
        
    end % constructor

end % construction function

%% Abstract methods
methods (Abstract)
    res = evaluate(this, params)
    % Evaluate the image to image metric
    
end % general methods

end % classdef
