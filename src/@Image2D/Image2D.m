classdef Image2D < ScalarImage
%IMAGE2D Planar image class
%
%   Wrapper for image data. This class encapsulates data buffer plus some
%   additional information such as spatial calibration, display calibration
%   or image name.
%
%   Image indexing is as follow:
%   - first coordinate is x, second is y
%   - index coordinate starts at 0 and finishes at dim(..)-1.
%   If imag matrix looks like :
%   [1  2  3  4;
%    5  6  7  8;
%    9 10 11 12], 
%   then the value of img(1, 2) is 10.
%
%
%   img = Image2D(data);
%   img.show();
%
%   Inner data buffer is stored transposed, such that first coordinate
%   corresponds to x, and second coordinate corresponds to y. 
%
%   Example
%   % create image from a matrix
%   img = imread('rice.png');
%   I = Image2D(img);
%   I.show();
%
%   % create image from a file name
%   I = Image2D('rice.png');
%   I.show();
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-04-20,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.


%% Static methods
methods(Static)
    function img = create(varargin)
        % static constructor for 2D image
        % example:
        % img = Image2D.create(imread('cameraman.tif'));
        % img.show();
        img = Image2D(varargin{:});
    end
    
    img = read(fileName, varargin)
end

%% Constructors
methods
    function this = Image2D(varargin)
        % Constructs a new Image2D object.
        
        if nargin==0
            % initialize with an empty 2D array
            varargin = {'data', []};
        elseif isa(varargin{1}, 'Image2D')
            % copy constructor: use parameter as parent for new image
            var = varargin{1};
            varargin = [...
                {'data', var.data} ...
                {'parent', var} ...
                varargin(2:end)]; 
        else
            var = varargin{1};
            if isnumeric(var)
                % first parameter is a numeric array, containing image data
                varargin = [{'data', var'} varargin(2:end)]; 
            end
        end

        % call the parent constructor, possibly using some parameters
        this = this@ScalarImage(2, varargin{:});
        
    end % constructor declaration
end


%% Standard methods
methods
    function p = getPixel(this, x, y)
        % Returns a pixel in an image
        %   P = IMG.getPixel(X, Y)
        %   X is column index, Y is row index, both 0-indexed.
        p = this.data(x, y);
    end
  
    function p = getPixels(this, x, y)
        % Returns pixel array in an image
        %   P = IMG.getPixel(X, Y)
        %   X is column index, Y is row index, both 0-indexed.
        %   Result P has the same size as X and Y, and the same class as
        %   pixel array.
        p = zeros(size(x), class(this.data));
        p(:) = this.data((y-1)*this.dataSize(1) + x);
    end

    function setPixel(this, x, y, v)
        % Changes value of a pixel
        %   P = IMG.setPixel(X, Y, VALUE)
        %   X is column index, Y is row index, both 0-indexed.
        %   VALUE should be the same type as the buffer type.
        this.data(x, y) = v;
    end
    
    function dat = getBuffer(this)
        % Returns the inner buffer of the image
        %   
        %   D = IMG.getBuffer();
        %   The array D can be used as a classical array.
        dat = this.data';
    end
    
    function setBuffer(this, data)
        % Set up the inner buffer of an image
        %   
        %   D = IMG.setBuffer(DATA);
        %   Initialize the inner buffer of the image with the given array.
        this.data   = data';
        this.dataSize = size(this.data);
    end
    
    
    %% Display methods
    
    function imshow(this, varargin)
        % Overloads Matlab's imshow to call the show function
        this.show(varargin{:});
    end
    
    function display(this, varargin)
        % Shows image on current axis
        this.show(varargin{:});
    end
    
end % public methods declaration

end % end of class

