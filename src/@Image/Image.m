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
    Data            = [];
    
    % Size of data buffer(in x,y,z,c,t order), should always have length=5
    DataSize        = [1 1 1 1 1];
    
    % Number of spatial dimensions of the image, between 0 (single value)
    % and 3 (volume image). Common value is 2 (planar image).
    Dimension       = 1;
    
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
    Type            = 'grayscale';
        
    % Image name, empty by default
    Name            = '';
    
    % boolean flag indicating whether the image is calibrated or not
    Calibrated      = false;
    
    % spatial origin of image
    % corresponding to position of pixel (1,1) or voxel (1,1,1)
    Origin          = [1 1];
    
    % the amount of space between two pixels or voxels
    Spacing         = [1 1];
    
    % the name of the spatial unit
    UnitName        = '';
    
    % the name of each of the axes
    AxisNames       = {};
    
    % the name of the channels
    ChannelNames    = {};
    
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
    
    se = defaultStructuringElement(obj, varargin)
end

%% Constructor declaration
methods
    function obj = Image(varargin)
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
            if islogical(img.Data)
                obj.Data   = false(size(img.Data));
            else
                obj.Data   = zeros(size(img.Data), 'like', img.Data);
            end
            obj.Data(:)    = img.Data(:);
            obj.DataSize   = img.DataSize;
            obj.Dimension  = img.Dimension;
            
            % update private fields
            obj.copyFields(img);

        elseif isnumeric(varargin{1}) || islogical(varargin{1})
            % first argument is either data buffer, or image dimension
            
            if isscalar(varargin{1})
                % if argument is scalar, obj is the image dimension
                obj.DataSize = ones(1, 5);
                nd = varargin{1};
                obj.Dimension = nd;
                
            else
                % initialize data buffer from matlab array
                initFromMatlabArray(varargin{1});
                
            end
            varargin(1) = [];
            
            % update other data depending on image dimension
            initCalibration(obj);
        
        end
        
        % assumes there are pairs of param-values
        while length(varargin) > 1
            varName = lower(varargin{1});
            value = varargin{2};
            
            switch varName
                case 'data'
                    setInnerData(obj, value);
                    initDimension(obj);
                    initCalibration(obj);
                    
                case 'parent'
                    obj.copyFields(value);
                    
                case 'name'
                    obj.Name = value;
                    
                case 'dimension'
                    obj.Dimension = value;
                    initCalibration(obj);
                    
                case 'type'
                    obj.Type = value;
                case 'vector'
                    % if vector image is forced, permute dims 3 and 4
                    if value
                        setInnerData(obj, permute(obj.Data, [1 2 4 3 5]));
                        initDimension(obj);
                        initCalibration(obj);
                    end
                    
                case 'origin'
                    obj.Origin = value;
                case 'spacing'
                    obj.Spacing = value;
                    
                case 'unitname'
                    obj.UnitName = value;
                case 'axisnames'
                    obj.AxisNames = value;
                case 'channelnames'
                    obj.ChannelNames = value;
                    
                otherwise
                    error(['Unknown parameter name: ' varName]);
            end
            
            % switch to next couple of arguments
            varargin(1:2) = [];
        end
       
        % additional setup
        if strcmp(obj.Type, 'color') && isempty(obj.ChannelNames)
            obj.ChannelNames = {'red', 'green', 'blue'};
        end
        if strcmp(obj.Type, 'complex') && isempty(obj.ChannelNames)
            obj.ChannelNames = {'real', 'imaginary'};
        end
    
        
        function initFromMatlabArray(mat)
            % Initialize inner data assuming argument is a Matlab matrix

            % matrix size
            imageSize = size(mat);
            nd = length(imageSize);
            
            % check if image is color or grayscale
            if nd == 3 && imageSize(3) == 3 && sum(imageSize(1:2) > 5) == 2
                % init color image
                setInnerData(obj, permute(mat, [2 1 4 3 5]));
            else
                % init grayscale
                setInnerData(obj, permute(mat, [2 1 3:nd]));
            end
            
            initDimension(obj);
        end
    end
end % constructor       


%% Protected utilitary methods
methods (Access = protected)
    function copyFields(obj, that)
        % Initialize inner fields with the fields of the parameter image
        % Does not copy the data buffer.
        
        obj.Name   = that.Name;
        
        if isCompatibleType(obj, that.Type)
            obj.Type   = that.Type;
        end
        
        % copy dimension elements that are common
        nd = min(obj.Dimension, that.Dimension);
        obj.Calibrated = that.Calibrated;
        obj.Origin(1:nd)     = that.Origin(1:nd);
        obj.Spacing(1:nd)    = that.Spacing(1:nd);
        if ~isempty(that.UnitName)
            obj.UnitName(1:nd)   = that.UnitName(1:nd);
        end
        if ~isempty(that.AxisNames)
            obj.AxisNames(1:nd)  = that.AxisNames(1:nd);
        end
    end
    
    function tf = isCompatibleType(obj, typeName)
        tf = true;
        nc = obj.DataSize(4);
        switch lower(typeName)
            case 'binary', if nc ~= 1, tf = false; end
            case 'grayscale', if nc ~= 1, tf = false; end
            case 'intensity', if nc ~= 1, tf = false; end
            case 'color', if nc ~= 3, tf = false; end
            case 'label', if nc ~= 1, tf = false; end
            case 'vector', if nc == 1, tf = false; end
            case 'complex', if nc ~= 2, tf = false; end
            otherwise 
                warning(['unknown type: ' typeName]);
        end
    end
    
    function setInnerData(obj, data)
        % Initialize data buffer and computes its size
        obj.Data = data;
        
        % determines size of data buffer
        siz = size(obj.Data);
        obj.DataSize(1:length(siz)) = siz;
        
        initImageType(obj);
    end
    
    function initImageType(obj)
        % Determines a priori the type of image
        if islogical(obj.Data)
            obj.Type = 'binary';
        elseif isfloat(obj.Data)
            obj.Type = 'intensity';
        elseif obj.DataSize(4) == 3
            obj.Type = 'color';
        elseif obj.DataSize(4) == 2
            obj.Type = 'complex';
        elseif obj.DataSize(4) > 3
            obj.Type = 'vector';
        end
    end

    function initDimension(obj)
        % Automatically determines dimension of image from data array
        
        % compute image dim, 
        dims = obj.DataSize;
        
        nd = 3;
        if dims(3) == 1
            nd = 2;
            if dims(2) == 1
                nd = 1;
            end
        end        
        obj.Dimension = nd;
    end
    
    function initCalibration(obj)
        % Initializes spatial calibration of image based on its dimension.
        nd = obj.Dimension;
        obj.Origin  = ones(1, nd);
        obj.Spacing = ones(1, nd);
        obj.Calibrated = false;
    end
end % protected methods


%% Spatial calibration methods
methods
    function copySpatialCalibration(obj, that)
        %copySpatialCalibration copy spatial calibration
        %
        % copySpatialCalibration(THIS, THAT)
        % Copies the spatial calibration from THAT image to THIS image.
        
        obj.Origin     = that.Origin;
        obj.Spacing    = that.Spacing;
        obj.UnitName   = that.UnitName;
        obj.Calibrated = that.Calibrated;
    end
    
    function ori = get.Origin(obj)
        % Return image origin
        ori = obj.Origin;
    end
    
    function set.Origin(obj, origin)
        % Change image origin
        obj.Origin = origin;
        obj.Calibrated = true; %#ok<MCSUP>
    end
    
    function ori = get.Spacing(obj)
        % Return image spacing
        ori = obj.Spacing;
    end
    
    function set.Spacing(obj, spacing)
        % Change image spacing
        obj.Spacing = spacing;
        obj.Calibrated = true; %#ok<MCSUP>
    end

    function name = get.UnitName(obj)
        name = obj.UnitName;
    end
    
    function set.UnitName(obj, newName)
        obj.UnitName = newName;
        obj.Calibrated = true; %#ok<MCSUP>
    end
    
    function [index, isInside] = pointToIndex(obj, point)
        % Converts point in physical coordinate into image index

        % repeat points avoiding repmat
        nI = ones(size(point, 1), 1);
        index = round((point - obj.Origin(nI, :)) ./ obj.Spacing(nI, :)) + 1;

        if nargout > 1
            isInside = true(size(nI));
            isInside(find(sum(index <= 0, 2))) = false; %#ok<*FNDSB>
            isInside(find(sum(index >  obj.DataSize(nI,:), 2))) = false;
        end
    end
    
    function [point, isInside] = pointToContinuousIndex(obj, point)
        % Converts point in physical coordinate into unrounded image index
        
        for i = 1:length(obj.Spacing)
            point(:,i) = (point(:,i) - obj.Origin(i)) / obj.Spacing(i) + 1;
        end
        
        if nargout > 1
            % check if resulting points are inside the image
            n = size(point, 1);
            isInside = true(size(n));
            isInside(find(sum(point <= 0, 2))) = false;
            isInside(find(sum(point >  obj.DataSize(n,:), 2))) = false;
        end
    end
    
    function point = indexToPoint(obj, index)
        % Converts image index into point in physical coordinate
        
        nI = ones(size(index, 1), 1);
        point = (index - 1) .* obj.Spacing(nI, :) + obj.Origin(nI, :);
    end
    
end % methods

end %classdef
