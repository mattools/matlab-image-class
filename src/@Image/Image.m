classdef Image < handle
%Image class that handles up to 3 spatial dimensions, channels, and time
%   
%   For a detailed description, type 'doc @Image'. For the complete list of
%   functions operating on images objects, type 'methods('Image')'.
%   For help on a specific method, type 'help Image/methodName'.
%
%   Example
%     img = Image.read('cameraman.tif');
%     show(img);
%     figure; histogram(img);
%     figure; show(img > 50);
%   
%   See also
%     show, histogram, lineProfile, sum, mean, filter, gaussianFilter
%     slice, channel, splitChannels, isColorImage, isGrayscaleImage
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2009-04-20,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.

%% Declaration of class properties
properties
    % Inner data of image
    data            = [];
    
    % Size of data buffer(in x,y,z,c,t order), should always have length=5
    dataSize        = [1 1 1 1 1];
    
    % Number of spatial dimensions of the image, between 0 (single value)
    % and 3 (volume image). Common value is 2 (planar image).
    dimension       = 1;
    
    % The type of image (grayscale, color, complex...)
    % It is represented by one of the following strings:
    % 'binary', data buffer contains one channel of logical values
    % 'grayscale' (the default), data buffer contains 1 channel (int)
    % 'intensity', data buffer contains 1 channel coded as single or double
    % 'color', data buffer contains 3 channels
    % 'label', data buffer contains 1 channel
    % 'vector', data buffer contains several channels
    % 'complex', data buffer contains 2 channels
    % 'unknown'
    type            = 'grayscale';
        
    % Image name, empty by default
    name            = '';
    
    % boolean flag indicating whether the image is calibrated or not
    calibrated      = false;
    
    % spatial origin of image
    % corresponding to position of pixel (1,1) or voxel (1,1,1)
    origin          = [1 1];
    
    % the amount of space between two pixels or voxels
    spacing         = [1 1];
    
    % the name of the spatial unit
    unitName        = '';
    
    % the name of each of the axes
    axisNames       = {};
    
    % the name of the channels
    channelNames    = {};
    
end

%% Static methods
methods (Static)
    img = create(varargin)
    img = createRGB(varargin)
    img = ones(varargin)
    img = zeros(varargin)
    
    img = read(fileName, varargin)

    img = readSeries(fileName, varargin)
    
    [sx, sy, sz] = create3dGradientKernels(varargin)
    % Create kernels for gradient computations
    
end % static methods


%% Private Static methods
methods (Static, Access = protected)
    info = metaImageInfo(fileName)
    img = metaImageRead(info)
    
    img = readstack(fileName, varargin)

    axis = parseAxisIndex(axis)
    % convert index or string to index    
    
end % static methods

%% Private methods
methods(Access = protected)
    
    se = defaultStructuringElement(this, varargin)
end

%% Constructor declaration
methods
    function this = Image(varargin)
        %IMAGE Constructor for Image object.
        %
        %   Syntax
        %   IMG = Image(MAT);
        %   Creates a new image from a Matlab array. Image size, type and
        %   dimension are determined automatically from array size and
        %   type.
        %
        %   IMG = Image('data', DATA);
        %   Creates a new image by specifying the inner data array of the
        %   image. Useful to creates an image based on the data of another
        %   image.
        %   
        %   IMG = Image(..., PARAM, VALUE);
        %   Specify additional parameters for initializing image.
        %
        %   Example
        %     img = Image.read('cameraman.tif');
        %     img.show();
        %     figure; img.histogram;
        %     figure; show(img > 50);
        %
        
        if nargin == 0
            % empty constructor
            % (nothing to do !)
            
        elseif isa(varargin{1}, 'Image')
            % copy constructor
            
            img = varargin{1};
            varargin(1) = [];
            if islogical(img.data)
                this.data   = false(size(img.data));
            else
                this.data   = zeros(size(img.data), 'like', img.data);
            end
            this.data(:)    = img.data(:);
            this.dataSize   = img.dataSize;

            % update private fields
            this.copyFields(img);

        elseif isnumeric(varargin{1}) || islogical(varargin{1})
            % first argument is either data buffer, or image dimension
            
            if isscalar(varargin{1})
                % if argument is scalar, this is the image dimension
                this.dataSize = ones(1, 5);
                nd = varargin{1};
                this.dimension = nd;
                
            else
                % initialize data buffer from matlab array
                initFromMatlabArray(varargin{1});
                
            end
            varargin(1) = [];
            
            % update other data depending on image dimension
            initCalibration(this);
        
        end
        
        % assumes there are pairs of param-values
        while length(varargin) > 1
            varName = lower(varargin{1});
            value = varargin{2};
            
            switch varName
                case 'data'
                    setInnerData(this, value);
                    initDimension(this);
                    initCalibration(this);
                    
                case 'parent'
                    this.copyFields(value);
                    
                case 'name'
                    this.name = value;
                    
                case 'dimension'
                    this.dimension = value;
                    initCalibration(this);
                    
                case 'type'
                    this.type = value;
                case 'vector'
                    % if vector image is forced, permute dims 3 and 4
                    if value
                        setInnerData(this, permute(this.data, [1 2 4 3 5]));
                        initDimension(this);
                        initCalibration(this);
                    end
                    
                case 'origin'
                    this.origin = value;
                case 'spacing'
                    this.spacing = value;
                    
                case 'unitname'
                    this.unitName = value;
                case 'axisnames'
                    this.axisNames = value;
                case 'channelnames'
                    this.channelNames = value;
                    
                otherwise
                    error(['Unknown parameter name: ' varName]);
            end
            
            % switch to next couple of arguments
            varargin(1:2) = [];
        end
       
        % additional setup
        if strcmp(this.type, 'color') && isempty(this.channelNames)
            this.channelNames = {'red', 'green', 'blue'};
        end
        if strcmp(this.type, 'complex') && isempty(this.channelNames)
            this.channelNames = {'real', 'imaginary'};
        end
    
        
        function initFromMatlabArray(mat)
            % Initialize inner data assuming argument is a Matlab matrix

            % matrix size
            imageSize = size(mat);
            nd = length(imageSize);
            
            % check if image is color or grayscale
            if nd == 3 && imageSize(3) == 3 && sum(imageSize(1:2) > 5) == 2
                % init color image
                setInnerData(this, permute(mat, [2 1 4 3 5]));
            else
                % init grayscale
                setInnerData(this, permute(mat, [2 1 3:nd]));
            end
            
            initDimension(this);
        end
    end
end % constructor       


%% Protected utilitary methods
methods (Access = protected)
    function copyFields(this, that)
        % Initialize inner fields with the fields of the parameter image
        % Does not copy the data buffer.
        this.name   = that.name;
        this.type   = that.type;
        
        % copy dimension elements that are common
        nd = min(this.dimension, that.dimension);
        this.calibrated = that.calibrated;
        this.origin(1:nd)     = that.origin(1:nd);
        this.spacing(1:nd)    = that.spacing(1:nd);
        if ~isempty(that.unitName)
            this.unitName(1:nd)   = that.unitName(1:nd);
        end
        if ~isempty(that.axisNames)
            this.axisNames(1:nd)  = that.axisNames(1:nd);
        end
    end
    
    function setInnerData(this, data)
        % Initialize data buffer and computes its size
        this.data = data;
        
        % determines size of data buffer
        siz = size(this.data);
        this.dataSize(1:length(siz)) = siz;
        
        initImageType(this);
    end
    
    function initImageType(this)
        % Determines a priori the type of image
        if islogical(this.data)
            this.type = 'binary';
        elseif isfloat(this.data)
            this.type = 'intensity';
        elseif this.dataSize(4) == 3
            this.type = 'color';
        elseif this.dataSize(4) == 2
            this.type = 'complex';
        elseif this.dataSize(4) > 3
            this.type = 'vector';
        end
    end

    function initDimension(this)
        % Automatically determines dimension of image from data array
        
        % compute image dim, 
        dims = this.dataSize;
        
        nd = 3;
        if dims(3) == 1
            nd = 2;
            if dims(2) == 1
                nd = 1;
            end
        end        
        this.dimension = nd;
    end
    
    function initCalibration(this)
        % Initializes spatial calibration of image based on its dimension.
        nd = this.dimension;
        this.origin  = ones(1, nd);
        this.spacing = ones(1, nd);
        this.calibrated = false;
    end
end % protected methods


%% Spatial calibration methods
methods
    function copySpatialCalibration(this, that)
        %copySpatialCalibration copy spatial calibration
        %
        % copySpatialCalibration(THIS, THAT)
        % Copies the spatial calibration from THAT image to THIS image.
        
        this.origin     = that.origin;
        this.spacing    = that.spacing;
        this.unitName   = that.unitName;
        this.calibrated = that.calibrated;
    end
    
    function ori = get.origin(this)
        % Return image origin
        ori = this.origin;
    end
    
    function set.origin(this, origin)
        % Change image origin
        this.origin = origin;
        this.calibrated = true; %#ok<MCSUP>
    end
    
    function ori = get.spacing(this)
        % Return image spacing
        ori = this.spacing;
    end
    
    function set.spacing(this, spacing)
        % Change image spacing
        this.spacing = spacing;
        this.calibrated = true; %#ok<MCSUP>
    end

    function name = get.unitName(this)
        name = this.unitName;
    end
    
    function set.unitName(this, newName)
        this.unitName = newName;
        this.calibrated = true; %#ok<MCSUP>
    end
    
    function [index, isInside] = pointToIndex(this, point)
        % Converts point in physical coordinate into image index

        % repeat points avoiding repmat
        nI = ones(size(point, 1), 1);
        index = round((point - this.origin(nI, :)) ./ this.spacing(nI, :)) + 1;

        if nargout > 1
            isInside = true(size(nI));
            isInside(find(sum(index <= 0, 2))) = false; %#ok<*FNDSB>
            isInside(find(sum(index >  this.dataSize(nI,:), 2))) = false;
        end
    end
    
    function [point, isInside] = pointToContinuousIndex(this, point)
        % Converts point in physical coordinate into unrounded image index
        
        for i = 1:length(this.spacing)
            point(:,i) = (point(:,i) - this.origin(i)) / this.spacing(i) + 1;
        end
        
        if nargout > 1
            % check if resulting points are inside the image
            n = size(point, 1);
            isInside = true(size(n));
            isInside(find(sum(point <= 0, 2))) = false;
            isInside(find(sum(point >  this.dataSize(n,:), 2))) = false;
        end
    end
    
    function point = indexToPoint(this, index)
        % Converts image index into point in physical coordinate
        
        nI = ones(size(index, 1), 1);
        point = (index - 1) .* this.spacing(nI, :) + this.origin(nI, :);
    end
    
end % methods

end %classdef
