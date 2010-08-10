classdef VectorImage2D < Image
%VECTORIMAGE2D  One-line description here, please.
%   output = VectorImage2D(input)
%
%   Example
%   VectorImage2D
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-24,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Constructors
methods
    function this = VectorImage2D(varargin)
        % Constructs a new Image2D object.
        
        if nargin==0
            % initialize with an empty 2D array
            varargin = {'data', []};
        elseif isa(varargin{1}, 'Image')
            % copy constructor: use parameter as parent for new image
            var = varargin{1};
            varargin = [...
                {'data', var.data} ...
                {'parent', var} ...
                varargin(2:end)]; 
        elseif isnumeric(varargin{1})
            var = varargin{1};
            if ndims(var)>2
                % first parameter is a numeric array, containing image data
                varargin = {'data', permute(var, [2 1 3])};
            else
                data = zeros([size(var) nargin], class(var));
                for i=1:nargin
                    data(:,:,i) = varargin{i}';
                end
                varargin = {'data', data};
            end
        end

        % call the parent constructor, possibly using some parameters
        this = this@Image(2, varargin{:});

        % compute size of inner buffer, then keep the first 2 dimensions
        siz = size(this.data);
        this.dataSize = siz(1:2);
    end % constructor declaration
end

%% Protected utilitary methods
methods (Access = protected)
    function setInnerData(this, data)
        % Override the method of Image, to take into account vector dim
        this.data = data;
        siz = size(this.data);
        this.dataSize = siz(1:2);
    end
    
end % protected methods


%% Standard methods
methods
    function n = getComponentNumber(this)
        %Returns the number of components of inner vectors
        %   S = IMG.getSize();
        
        n = size(this.data, 3);
    end
    
    function p = getPixel(this, x, y)
        % Returns a pixel in an image
        %   P = IMG.getPixel(X, Y)
        %   X is column index, Y is row index, both 0-indexed.
        p = squeeze(this.data(x+1, y+1, :))';
    end
  
    function p = getValue(this, x, y, c)
        % Returns a given component value of a given pixel
        %   P = IMG.getValue(X, Y, C)
        %   X is column index, Y is row index, both 0-indexed.
        %   C is the component number, 0 indexed
        p = squeeze(this.data(x+1, y+1, c+1));
    end
    
    function p = getPixels(this, x, y)
        % Returns pixel array in an image
        %   P = IMG.getPixels(X, Y)
        %   X is column index, Y is row index, both 0-indexed.
        %   Result P has as many rows as the number of elements in X, and
        %   as many columns as the number of vector components of image.
        nc = size(this.data, 3);
        p = zeros([numel(x) nc], class(this.data));
        for i=1:numel(x)
            p(i, :) = squeeze(this.data(x+1, y+1, :));
        end
    end

    function setPixel(this, x, y, v)
        % Changes value of a pixel
        %   P = IMG.setPixel(X, Y, VALUES)
        %   X is column index, Y is row index, both 0-indexed.
        %   VALUE should be the same type as the buffer type.
        this.data(x+1, y+1, :) = v;
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
        this.setInnerData(permute(data, [2 1 3]));
    end
        
end % methods 

end % classdef
