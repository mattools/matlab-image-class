classdef NearestNeighborGradientEvaluator < ImageFunction
%NearestNeighborGradientEvaluator  One-line description here, please.
%
%   output = NearestNeighborGradientEvaluator(input)
%
%   Example
%   NearestNeighborGradientEvaluator
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    % the image whom gradient will be evaluated
    image;
    
    % output type of interpolation, double by default
    outputType = 'double';

    % default value for points outside image
    defaultValue = NaN;
    
    % the filters used for gradient evaluation in each direction.
    % should be a cell array with as many columns as image dimension.
    filters;
end

%% Constructors
methods
    function this = NearestNeighborGradientEvaluator(varargin)
       
        if nargin == 0
            return;
        end
        
        % extract image to interpolate
        var = varargin{1};
        if isa(var, 'NearestNeighborGradientEvaluator')
            this.image = var.image;
        elseif isa(var, 'Image')
            this.image = var;
        end
        varargin(1) = [];
        
        if this.image.getChannelNumber() > 1
            error('Gradient of vector images is not supported');
        end
        
        % setup default values depending on image dimension
        nd = getDimension(this.image);
        switch nd
            case 1
                this.filters = {[1 0 -1]'};
            case 2
                sx = fspecial('sobel')'/8;
                this.filters = {sx, sx'};
            case 3
                [sx sy sz] = Image.create3dGradientKernels();
                this.filters = {sx, sy, sz};
        end
        
        % parse user specified options
        while length(varargin) > 1
            paramName = varargin{1};
            if strcmpi(paramName, 'defaultValue')
                this.defaultValue = varargin{2};
                
            elseif strcmpi(paramName, 'filters')
                this.defaultValue = varargin{2};
                
            elseif strcmpi(paramName, 'outputType')
                this.outputType = varargin{2};
                
            else
                error(['Unknown parameter name: ' paramName]);
            end
            
            varargin(1:2) = [];
        end
    end
end

end