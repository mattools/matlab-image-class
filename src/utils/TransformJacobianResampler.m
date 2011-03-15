classdef TransformJacobianResampler < handle
%TRANSFORMJACOBIANRESAMPLER Create a new image showing jacobian of a transform 
%
%   output = TransformJacobianResampler(input)
%
%   Example
%   TransformJacobianResampler
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Declaration of class properties
properties
%     % the transform from whom the jcaobian will be computed
%     transform;
    
    % The size of the resulting image
    outputSize = [];

    % Data type of resulting image, default is 'uint8'.
    outputType = 'double';
    
    % physical origin of image first point
    origin = [];

    % Physical spacing between pixels
    spacing = [];
end

%TODO: specify output type;

%% Constructors
methods
    function this = TransformJacobianResampler(varargin)
        % Constructs a new TransformJacobianResampler object.

        if isa(varargin{1}, 'TransformJacobianResampler')
            % copy constructor

            % copy each field
            var = varargin{1};
            this.outputSize = var.outputSize;
            this.origin     = var.origin;
            this.spacing    = var.spacing;
            
        elseif isa(varargin{1}, 'Image')
            % Initialize fields from a given image
            img = varargin{1};
            this.outputSize = img.getSize();
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
        
%         if nargin > 1
%             this.transform = varargin{1};
%         end
        
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
    
%     function setTransform(this, transfo)
%         % Specifiy the transform for jacobian computation
%         this.transform = transfo;
%     end
%     
%     function transfo = getTransform(this)
%         % Return the transform
%         transfo = this.transform;
%     end
    
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
            error('Need to specify a transform');
        end
        
        transform = varargin{1};
        
        % precompute grid basis for 2D
        lx = (0:this.outputSize(1)-1)*this.spacing(1) + this.origin(1);
        ly = (0:this.outputSize(2)-1)*this.spacing(2) + this.origin(2);
        
        % different processing depending on image dimension
        outputDim = length(this.outputSize);
        if outputDim==2
            % Process 2D images
            
            % sample grid
            [x y] = meshgrid(lx, ly);

            % initialize result array
            vals = zeros(size(x), this.outputType);
        
            % compute all jacobians (result stored in a 2*2*N array)
            jac = transform.getJacobian([x(:) y(:)]);
            for i=1:numel(x)
                vals(i) = det(jac(:,:,i));
            end

%             % compute result values
%             for i=1:numel(x)
%                 jac = transform.getJacobian([x(i) y(i)]);
%                 vals(i) = det(jac(:,:)' * jac(:,:));
%             end

        elseif outputDim==3
            % Process 3D images
            
            % sample grid
            lz = (0:this.outputSize(3)-1)*this.spacing(3) + this.origin(3);
            [x y z] = meshgrid(lx, ly, lz);
            
            % initialize result array
            vals = zeros(size(x), this.outputType);
        
            % compute result values
            for i=1:numel(x)
                jac = transform.getJacobian([x(i) y(i) z(i)]);
                vals(i) = det(jac(:,:,i));
            end
            
        else
            % TODO: implement for greater dimensions ?
            error('Resampling is only implemented for dimensions 2 and 3');
        end
        
        % create a new Image from the result
        img2 = Image.create(vals);
        
        % copy spatial calibration info to image
        img2.setOrigin(this.origin);
        img2.setSpacing(this.spacing);
    end

end % methods


end % classef 
