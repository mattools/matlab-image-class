classdef Image < handle
%Image class that handles up to 3 spatial dimensions, channels, and time
%   
%   For a detailed description, type 'doc @Image'. For help on a specific
%   method, type 'help Image/methodName'.
%
%   Example
%     img = Image.read('cameraman.tif');
%     img.show();
%     figure; img.histogram;
%     figure; show(img > 50);
%   
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-04-20,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.

%% Declaration of class properties
properties
    % Inner data of image
    data            = [];
    
    % Size of data buffer(in x,y,z,c,t order), should always have length=5
    dataSize        = [1 1 1 1 1];
    
    % number of spatial dimensions of the image, between 0 and 3.
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
    origin          = [0 0];
    
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
    
    img = read(fileName, varargin)
    
    [sx sy sz] = create3dGradientKernels(varargin)
    % Create kernels for gradient computations
    
end % static methods


%% Private Static methods
methods (Static, Access = protected)
    info = metaImageInfo(fileName)
    img = metaImageRead(info)
end % static methods

%% Private static methods
methods(Static, Access=private)
    img = readstack(fileName, varargin)

    axis = parseAxisIndex(axis)
    % convert index or string to index    
    
end

%% Constructor declaration
methods (Access = protected)
    function this = Image(varargin)
        %IMAGE Constructor for Image object.
        
        if nargin==0
            % empty constructor
            % (nothing to do !)
            
        elseif isa(varargin{1}, 'Image')
            % copy constructor
            
            img = varargin{1};
            varargin(1) = [];
            this.data       = img.data;
            this.dataSize   = img.dataSize;

            % update private fields
            this.copyFields(img);

        else
            % Generic constructor: parse arguments and init image
            
            % first argument is either the data buffer, or the image dim
            if isnumeric(varargin{1}) || islogical(varargin{1})
                if isscalar(varargin{1})
                    % if argument is scalar, this is the image dimension
                    this.dataSize = ones(1, 5);
                    nd = varargin{1};
                else
                    % initialize data buffer and image size
                    setInnerData(this, varargin{1});
                    nd = ndims(varargin{1});
                end
                varargin(1) = [];
            else
                error('First argument need to be numeric: either dim or data');
            end
            
            % update other data depending on image dimension
            this.dimension = nd;
            this.origin  = zeros(1, nd);
            this.spacing = ones(1, nd);
        end
        
        % assumes there are pairs of param-values
        while length(varargin)>1
            varName = lower(varargin{1});
            value = varargin{2};
            
            switch varName
                case 'data'
                    this.setInnerData(value);
                case 'parent'
                    this.copyFields(value);
                case 'name'
                    this.name = value;
                case 'dimension'
                    this.dimension = value;
                case 'type'
                    this.type = value;
                case 'origin'
                    this.setOrigin(value);
                case 'spacing'
                    this.setSpacing(value);
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
            this.channelNames = {'Red', 'Green', 'Blue'};
        end
        if strcmp(this.type, 'complex') && isempty(this.channelNames)
            this.channelNames = {'Real', 'Imaginary'};
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
        
        this.calibrated = that.calibrated;
        this.origin     = that.origin;
        this.spacing    = that.spacing;
        this.unitName   = that.unitName;
        this.axisNames  = that.axisNames;
    end
    
    function setInnerData(this, data)
        % Initialize data buffer and computes its size
        this.data = data;
        
        % determines size of data buffer
        siz = size(this.data);
        this.dataSize(1:length(siz)) = siz;
        
        % determines a priori type of image
        if islogical(this.data)
            this.type = 'binary';
        elseif this.dataSize(4) == 3
            this.type = 'color';
        elseif this.dataSize(4) == 2
            this.type = 'complex';
        elseif this.dataSize(4) > 3
            this.type = 'vector';
        end
    end

end % protected methods


%% Spatial calibration methods
methods
   
    function ori = getOrigin(this)
        % Return image origin
        ori = this.origin;
    end
    
    function setOrigin(this, origin)
        % Change image origin
        this.origin = origin;
        this.calibrated = true;
    end
    
    function ori = getSpacing(this)
        % Return image spacing
        ori = this.spacing;
    end
    
    function setSpacing(this, spacing)
        % Change image spacing
        this.spacing = spacing;
        this.calibrated = true;
    end
       
    function [index isInside] = pointToIndex(this, point)
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
    
    function [point isInside] = pointToContinuousIndex(this, point)
        % Converts point in physical coordinate into unrounded image index
        
        % TODO: change name ? physicalToImageCoord ?
        for i = 1:length(this.spacing)
            point(:,i) = (point(:,i)- this.origin(i)) / this.spacing(i) + 1;
        end
        
        if nargout>1
            % check if resulting points are inside the image
            isInside = true(size(nI));
            isInside(find(sum(point <= 0, 2))) = false;
            isInside(find(sum(point >  this.dataSize(nI,:), 2))) = false;
        end
    end
    
    function point = indexToPoint(this, index)
        % Converts image index into point in physical coordinate
        point = (index - 1) .* this.spacing + this.origin;
    end
    
end % methods

end %classdef
