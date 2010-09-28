classdef VectorImage3D < Image
%VectorImage3D 3D Vector image class
%   output = VectorImage3D(input)
%
%   Example
%   VectorImage3D
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
    function this = VectorImage3D(varargin)
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
            if ndims(var)>3
                % first parameter is a numeric array, containing image data
                varargin = {'data', permute(var, [2 1 4 3])};
            else
                dim = [size(var, 2) size(var, 1) size(var, 3) nargin];
                data = zeros(dim, class(var));
                for i=1:nargin
                    data(:,:,:,i) = permute(varargin{i}, [2 1 3]);
                end
                varargin = {'data', data};
            end
        end

        % call the parent constructor, possibly using some parameters
        this = this@Image(3, varargin{:});

        % compute size of inner buffer, then keep the first 2 dimensions
        siz = size(this.data);
        this.dataSize = siz(1:3);
    end % constructor declaration
end

%% Protected utilitary methods
methods (Access = protected)
    function setInnerData(this, data)
        % Override the method of Image, to take into account vector dim
        this.data = data;
        siz = size(this.data);
        this.dataSize = siz(1:3);
    end
    
end % protected methods


%% Standard methods
methods
    function n = getChannelNumber(this)
        %Returns the number of channels of vector image
        %   S = IMG.getSize();
        
        n = size(this.data, 4);
    end
    
    function p = getPixel(this, x, y, z)
        % Returns a pixel in an image
        %   P = IMG.getPixel(X, Y, Z)
        %   X is column index, Y is row index, Z is slice index, all
        %   1-indexed. 
        p = squeeze(this.data(x, y, z, :))';
    end
  
    function p = getValue(this, x, y, z, c)
        % Returns a given component value of a given pixel
        %   P = IMG.getValue(X, Y, Z, C)
        %   X is column index, Y is row index, Z is slice index, all
        %   1-indexed. 
        %   C is the component number, 1 indexed
        p = squeeze(this.data(x, y, z, c));
    end
    
    function p = getPixels(this, x, y, z)
        % Returns pixel array in an image
        %   P = IMG.getPixels(X, Y, Z)
        %   X is column index, Y is row index, Z is slice index, all
        %   1-indexed. 
        %   Result P has as many rows as the number of elements in X, and
        %   as many columns as the number of vector components of image.
        nc = size(this.data, 4);
        p = zeros([numel(x) nc], class(this.data));
        for i=1:numel(x)
            p(i, :) = squeeze(this.data(x(i), y(i), z(i), :));
        end
    end

    function setPixel(this, x, y, z, v)
        % Changes value of a pixel
        %   P = IMG.setPixel(X, Y, Z, VALUES)
        %   X is column index, Y is row index, Z is slice index, all
        %   1-indexed. 
        %   VALUE should be the same type as the buffer type.
        this.data(x, y, z, :) = v(:);
    end
    
    function dat = getBuffer(this)
        % Returns the inner buffer of the image
        %   
        %   D = IMG.getBuffer();
        %   The array D can be used as a classical array, with:
        %   - dim 1 is Y
        %   - dim 2 is X
        %   - dim 3 is channel
        %   - dim 4 is Z
        dat = permute(this.data, [2 1 4 3]);
    end
    
    function setBuffer(this, data)
        % Set up the inner buffer of an image
        %   
        %   D = IMG.setBuffer(DATA);
        %   Initialize the inner buffer of the image with the given array.
        this.setInnerData(permute(data, [2 1 4 3]));
    end
        
end % methods 

end % classdef
