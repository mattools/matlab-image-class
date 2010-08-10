classdef Image3D < ScalarImage
%IMAGE3D Class representing a 3D image stored in a voxel matrix
%
%   img = Image3D(data);
%   img.show();
%
%   Example
%   % create image from a matrix
%   dat = ones([25 25 25]);
%   img = Image3D(dat);
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-04-20,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.


%% Public static methods
methods(Static)
    function img = create(varargin)
        % static constructor for 3D image
        % Simply call constructor with given arguments
        img = Image3D(varargin{:});
    end
    
    img = read(fileName, varargin)
end

%% Private static methods
methods(Static)
    img = readstack(fileName, varargin)
end

%% Constructors
methods
    function this = Image3D(varargin)
        % Constructs a new Image3D object.
        
        if nargin==0
            % initialize with an empty 3D array
            varargin = {'data', []};
        elseif isa(varargin{1}, 'Image3D')
            % copy constructor: use parameter as parent for new image
            varargin = [{'parent', varargin{1}} varargin(2:end)]; 
        else
            var = varargin{1};
            if isnumeric(var)
                % first parameter is a numeric array, containing image data
                data = permute(var, [2 1 3]);
                varargin = [{'data', data} varargin(2:end)]; 
            end
        end

        % call the parent constructor, possibly using some parameters
        this = this@ScalarImage(3, varargin{:});
    end % constructor declaration
end

%% Standard methods
methods
    function s = getSize(this)
        %Returns the size of an image
        %   S = IMG.getSize();
        s = this.dataSize;
    end
    
    function n = ndims(this)
        % Returns the number of dimensions of the image
        %   N = IMG.ndims();
        n = length(this.dataSize);
    end
    
    function p = getPixel(this, x, y, z)
        % Returns a pixel in an image
        %   P = IMG.getPixel(X, Y, Z)
        %   X is column index, Y is row index, both 0-indexed.
        p = this.data(x, y, z);
    end
  
    function p = getPixels(this, x, y, z)
        % Returns pixel array in an image
        %   P = IMG.getPixel(X, Y, Z)
        %   X is column index, Y is row index, both 0-indexed.
        %   Result P has the same size as X and Y, and the same class as
        %   pixel array.
        sizXY = this.dataSize(1)*this.dataSize(2);
        p = zeros(size(x), class(this.data));
        p(:) = this.data((z-1)*sizXY + (y-1)*this.dataSize(1) + x);
    end

    function setPixel(this, x, y, z, v)
        % Changes value of a pixel
        %   P = IMG.setPixel(X, Y, Z, VALUE)
        %   X is column index, Y is row index, both 0-indexed.
        %   VALUE should be the same type as the buffer type.
        this.data(x, y, z) = v;
    end
    
    function dat = getBuffer(this)
        % Returns the inner buffer of the image
        %   
        %   D = IMG.getBuffer();
        %   The array D can be used as a classical array.
        dat = permute(this.data, [2 1 3]);
    end
    
    function setBuffer(this, data)
        % Set up the inner buffer of an image
        %   
        %   D = IMG.setBuffer(DATA);
        %   Initialize the inner buffer of the image with the given array.
        this.data       = permute(data, [2 1 3]);
        this.dataSize   = size(data);
    end
    
end % public methods declaration

end % end of class

