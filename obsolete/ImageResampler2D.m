classdef ImageResampler2D < handle
%IMAGERESAMPLER2D  Resample a planar image using a given spatial basis
%
%   RES = ImageResampler2D(LX, LY);
%   RES = ImageResampler2D(BASE_IMAGE);
%
% %   the following is not yet implemented
% %   RES = ImageResampler2D('size', [100 100], 'origin', [0 0], ...
% %       'spacing', [1 1]);
%
%   Usage:
%   IMG = Image2D('cameraman.tif');
%   IMG2 = RES.resample(IMG, 'linear');
%
%   Example
%   ImageResampler2D
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Declaration of class properties
properties
    % Size of the resulting image
    size = [10 10];

    % Origin of image first point, in physical coordinate
    origin = [0 0];

    % spacing between pixels (in directions x and y respectively)
    spacing = [1 1];
end

%TODO: specify output type;

%% Constructors
methods
    function this = ImageResampler2D(varargin)
        % Constructs a new ImageResampler2D object.

        if isa(varargin{1}, 'ImageResampler2D')
            % copy constructor

            % copy each field
            var = varargin{1};
            this.size       = var.size;
            this.origin     = var.origin;
            this.spacing    = var.spacing;
            
        elseif isa(varargin{1}, 'Image2D')
            % Initialize fields from a given image
            img = varargin{1};
            this.size       = img.getSize();
            this.origin     = img.getOrigin();
            this.spacing    = img.getSpacing();
            
        elseif isnumeric(varargin{1})
            % Gives lx and ly
            nbDims = length(varargin);
            this.size       = zeros(1, nbDims);
            this.origin     = zeros(1, nbDims);
            this.spacing    = ones(1, nbDims);
            for i=1:nbDims
                var = varargin{i};
                this.size(i)    = length(var);
                this.origin(i)  = var(1);
                this.spacing(i) = var(2)-var(1);
            end
        else
            error('Wrong parameter when constructing a linear interpolator');
        end
    end % constructor declaration
end % methods

methods
    
    function img2 = resample(this, varargin)
        % Resample an image, or an interpolated image
        % IMG2 = this.resample(IMG);
        var = varargin{1};
        if isa(var, 'ImageInterpolator2D')
            %TODO: use more general interpolators
            imgFun = var;
        else
            if isa(var, 'Image')
                img = var;
            elseif isnumeric(var)
                img = Image.create(var);
            else
                error('Please specify image to resample');
            end
            
            %TODO: specifiy interpolation method
            imgFun = LinearInterpolator2D(img);
        end
        
        % TODO: add psb to specify output type
        outputType = 'uint8';
        
        lx = (0:this.size(1)-1)*this.spacing(1) + this.origin(1);
        ly = (0:this.size(2)-1)*this.spacing(2) + this.origin(2);
        [x y] = meshgrid(lx, ly);
        vals = zeros(size(x), outputType); %#ok<CPROP,PROP>
        vals(:) = imgFun.evaluate([x(:) y(:)]);
        
        img2 = Image.create(vals);
        img2.setOrigin(this.origin);
        img2.setSpacing(this.spacing);
    end

end % abstract methods

end  % classdef