classdef BackwardTransformedImage2D < ImageInterpolator2D
% Describes an image associated with a backward transform
%   output = BackwardTransformedImage2D(input)
%
%   TIM = BackwardTransformedImage2D(IMG, TRANS, 'linear');
%   With IMG being the image to transform, TRANS the transformation, and
%   TYPE the interpolation type to be used.
%
%   TIM = BackwardTransformedImage2D(INTERP, TRANS);
%   Specifies directly an interpolator.
%
%   When the TIM object is evaluated at a given point, the point is first
%   transformed according to the stored transform, then the interpolated
%   image is evaluated at transformed position.
%
%
%   Example
%   % transform image using linear interpolator
%   img = Image2D('cameraman.tif')
%   trans = Translation2D(60, 40);
%   tim = BackwardTransformedImage2D(img, trans, 'linear');
%   tim.evaluate(10.5, 10.5);
%
%   % first define an interpolator
%   img = Image2D('cameraman.tif')
%   inter = LinearInterpolatore2D(img);
%   trans = Translation2D(60, 40);
%   tim = BackwardTransformedImage2D(inter, trans);
%   tim.evaluate(10.5, 10.5);
%   
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-04-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.
    
    %% Declaration of class properties
    properties
        % the reference image
        image   = [];
        
        % the transform from physial to image space
        trans   = [];
        
        % interpolator, that must refer to image
        interp  = [];
    end
    
    %% Static methods
    methods(Static)
        function tim = create(varargin)
            tim = BackwardTransformedImage2D(varargin{:});
        end
    end
    
    %% Constructors
    methods
        function this = BackwardTransformedImage2D(varargin)
            % Constructs a new BackwardTransformedImage2D object.
            if nargin==0
                % empty constructor
                % (nothing to do !)
                
            elseif isa(varargin{1}, 'BackwardTransformedImage2D')
                % copy constructor: copy each field
                tim = varargin{1};
                this.image  = tim.image;
                this.trans  = tim.trans;
                this.interp = tim.interp;
                
            elseif isa(varargin{1}, 'Image2D')
                this.image = varargin{1};
                this.trans = varargin{2};
                if length(varargin)>2
                    var = varargin{3};
                    if ischar(var)
                        this.interp = ImageInterpolator2D.create(this.image, var);
                    elseif isa(var, 'ImageInterpolator2D')
                        this.interp = var;
                        this.image = var.getImage();
                    end
                else
                    this.interp = LinearInterpolator2D(this.image);
                end
                
            elseif isa(varargin{1}, 'Image')
                this.image = varargin{1};
                this.trans = varargin{2};
                if length(varargin)>2
                    var = varargin{3};
                    if ischar(var)
                        this.interp = ImageInterpolator.create(this.image, var);
                    elseif isa(var, 'ImageInterpolator')
                        this.interp = var;
                        this.image = var.getImage();
                    end
                else
                    this.interp = LinearInterpolator2D(this.image);
                end
                
            elseif isa(varargin{1}, 'ImageInterpolator')
                this.interp = varargin{1};
                this.trans = varargin{2};
                this.image = this.interp.getImage();
            else
                error('Error in input arguments');
            end
        end % constructor declaration
    end
    
    %% private methods
    methods (Access = private)
  
    end % private methods
    
    %% Standard methods
    methods
    end
end

