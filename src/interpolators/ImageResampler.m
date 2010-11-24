classdef ImageResampler < handle
%IMAGERESAMPLER  Resample an image using a given spatial basis
%
%   RES = ImageResampler(LX, LY);
%   RES = ImageResampler(LX, LY, LZ);
%   RES = ImageResampler(BASE_IMAGE);
%
% %   the following is not yet implemented
% %   RES = ImageResampler('outputSize', [100 100], 'origin', [0 0], ...
% %       'spacing', [1 1]);
%
%   Usage:
%   IMG = Image2D('cameraman.tif');
%   IMG2 = RES.resample(IMG, 'linear');
%
%   Example
%   ImageResampler
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
    % The size of the resulting image
    outputSize = [];

    % Data type of resulting image, default is 'uint8'.
    outputType = 'uint8';
    
    % physical origin of image first point
    origin = [];

    % Physical spacing between pixels
    spacing = [];
end

%TODO: specify output type;

%% Constructors
methods
    function this = ImageResampler(varargin)
        % Constructs a new ImageResampler object.

        if isa(varargin{1}, 'ImageResampler')
            % copy constructor

            % copy each field
            var = varargin{1};
            this.outputSize = var.outputSize;
            this.outputType = var.outputType;
            this.origin     = var.origin;
            this.spacing    = var.spacing;
            
        elseif isa(varargin{1}, 'Image')
            % Initialize fields from a given image
            img = varargin{1};
            this.outputSize = img.getSize();
            this.outputType = img.getDataType();
            this.origin     = img.getOrigin();
            this.spacing    = img.getSpacing();
            
        elseif isnumeric(varargin{1})
            % Gives lx and ly
            nbDims = length(varargin);
            this.outputSize = zeros(1, nbDims);
            this.origin     = zeros(1, nbDims);
            this.spacing    = ones(1, nbDims);
            for i=1:nbDims
                var = varargin{i};
                this.outputSize(i)  = length(var);
                this.origin(i)      = var(1);
                this.spacing(i)     = var(2)-var(1);
            end
        else
            error('Wrong parameter when constructing an ImageResampler');
        end
    end % constructor declaration
end % methods

methods
    function setOutputType(this, dataType)
        % Specifiy the type of resulting image
        this.outputType = dataType;
    end
    
    function type = getOutputType(this)
        % Return the type of resulting image
        type = this.outputType;
    end
    
    function img2 = resample(this, varargin)
        % Resample an image, or an interpolated image
        %
        % IMG2 = this.resample(IMGFUN);
        % Use image function IMGFUN as reference. IMGFUN is an instance of 
        % ImageFunction, such as ImageInterpolator.
        %
        % IMG2 = this.resample(IMG);
        % Resample image IMG using linear interpolation.
        %
        % IMG2 = this.resample(IMG, TYPE);  
        % Resample image with specified interpolation type. TYPE can be:
        % 'linear' (default)
        % 'nearest', but is only supported for 2D images.
        %
        
        if isempty(varargin)
            error('Need to specify an image to resample');
        end
        
        var = varargin{1};
        if isa(var, 'ImageFunction')
            % if input is already an ImageFunction, nothing to do
            imgFun = var;
        else
            % extract input image
            if isa(var, 'Image')
                img = var;
            elseif isnumeric(var)
                img = Image.create(var);
            else
                error('Please specify image to resample');
            end
            
            % determines interpolation type
            interpolationType = 'linear';
            if length(varargin)>1
                interpolationType = varargin{2};
            end
            
            % create the appropriate image interpolator
            imgFun = ImageInterpolator.create(img, interpolationType);
        end
        
        outputDim = length(this.outputSize);
        
        lx = (0:this.outputSize(1)-1)*this.spacing(1) + this.origin(1);
        ly = (0:this.outputSize(2)-1)*this.spacing(2) + this.origin(2);
        if outputDim==2
            % Process 2D images
            [x y] = meshgrid(lx, ly);

            vals = zeros(size(x), this.outputType);
        
            vals(:) = imgFun.evaluate([x(:) y(:)]);
            img2 = Image.create(vals);
        elseif outputDim==3
            % Process 3D images
            lz = (0:this.outputSize(3)-1)*this.spacing(3) + this.origin(3);
            [x y z] = meshgrid(lx, ly, lz);
            vals = zeros(size(x), this.outputType);
        
            vals(:) = imgFun.evaluate([x(:) y(:) z(:)]);
            img2 = Image.create(vals);
        else
            % TODO: implement for greater dimensions ?
            error('Resampling is only implemented for dimensions 2 and 3');
        end
        
        % copy spatial calibration info to image
        img2.setOrigin(this.origin);
        img2.setSpacing(this.spacing);
    end

end % abstract methods

end  % classdef
