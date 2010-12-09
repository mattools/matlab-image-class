classdef Image < handle
%Image class that handles up to 3 spatial dimensions, channels, and time
%   
%   Example
%   
%   See also
%   
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-04-20,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.
% Licensed under the terms of the LGPL, see the file "license.txt"

%% Declaration of class properties
properties
    % Inner data of image
    data        = [];
    
    % Size of data buffer(in x,y,z,c,t order), should always have length=5
    dataSize    = [1 1 1 1 1];
    
    % The type of image (grayscale, color, complex...)
    % It is represented as one of the strings:
    % 'binary', data buffer contains one channel of logical values
    % 'grayscale' (the default), data buffer contains 1 channel
    % 'color', data buffer contains 3 channels
    % 'label', data buffer contains 1 channel
    % 'vector', data buffer contains several channels
    % 'complex', data buffer contains 2 channels
    % 'unknown'
    type        = 'grayscale';
    
    % Spatial calibration of image.
    calib;
    
    % Image name, empty by default
    name        = '';
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
            if isnumeric(varargin{1})
                if isscalar(varargin{1})
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
            this.calib  = SpatialCalibration(nd);
        end
        
        % assumes there are pairs of param-values
        while length(varargin)>1
            varName = varargin{1};
            value = varargin{2};
            
            switch varName
                case 'data'
                    this.setInnerData(value);
                case 'parent'
                    this.copyFields(value);
                case 'name'
                    this.name = value;
                case 'type'
                    this.type = value;
                case 'origin'
                    this.setOrigin(value);
                case 'spacing'
                    this.setSpacing(value);
                otherwise
                    error(['Unknown parameter name: ' varName]);
            end
            
            % switch to next couple of arguments
            varargin(1:2) = [];
        end
       
    end
end % constructor       


%% Protected utilitary methods
methods (Access = protected)
    function copyFields(this, that)
        % Initialize inner fields with the fields of the parameter image
        % Does not copy the data buffer.
        this.calib  = that.calib;
        this.name   = that.name;
        this.type   = that.type;
    end
    
    function setInnerData(this, data)
        % Initialize data buffer and computes its size
        this.data = data;
        
        siz = size(this.data);
        this.dataSize(1:length(siz)) = siz;
    end

end % protected methods


%% Spatial calibration methods
methods
   
    function calib = getSpatialCalibration(this)
        % Return spatial calibration of image
        %
        % CALIB = img.getSpatialCalibration();
        calib = this.calib;
    end
    
    function setSpatialCalibration(this, calib)
        % Change spatial calibration of image
        %
        % img.setSpatialCalibration(CALIB);
        this.calib = calib;
    end
    
    function ori = getOrigin(this)
        % Return image origin
        ori = this.calib.origin;
    end
    
    function setOrigin(this, origin)
        % Change image origin
        this.calib.origin = origin;
        this.calib.calibrated = true;
    end
    
    function ori = getSpacing(this)
        % Return image spacing
        ori = this.calib.spacing;
    end
    
    function setSpacing(this, spacing)
        % Change image spacing
        this.calib.spacing = spacing;
        this.calib.calibrated = true;
    end
       
    function [index isInside] = pointToIndex(this, point)
        % Converts point in physical coordinate into image index

        % Extract spatial calibration
        spacing = this.calib.spacing;
        origin = this.calib.origin;

        % repeat points avoiding repmat
        nI = ones(size(point, 1),1);
        index = round((point - origin(nI, :))./spacing(nI, :)) + 1;

        if nargout>1
            isInside = true(size(nI));
            isInside(find(sum(index<=0,2))) = false; %#ok<*FNDSB>
            isInside(find(sum(index>this.dataSize(nI,:),2))) = false;
        end
    end
    
    function [point isInside] = pointToContinuousIndex(this, point)
        % Converts point in physical coordinate into unrounded image index
        
        % Extract spatial calibration
        spacing = this.calib.spacing;
        origin = this.calib.origin;

        % TODO: change name ? physicalToImageCoord ?
%         nI = ones(size(point, 1),1); % repeat points avoiding repmat
%         index = (point - origin(nI, :))./spacing(nI, :) + 1;
        for i=1:length(this.calib.spacing)
            point(:,i) = (point(:,i)- origin(i))/spacing(i) + 1;
        end
        
        if nargout>1
            % check if resulting points are inside the image
            isInside = true(size(nI));
            isInside(find(sum(point<=0, 2))) = false;
            isInside(find(sum(point>this.dataSize(nI,:), 2))) = false;
        end
    end
    
    function point = indexToPoint(this, index)
        % Converts image index into point in physical coordinate
        point = (index-1).*this.calib.spacing + this.calib.origin;
    end
    
end % methods

end %classdef
