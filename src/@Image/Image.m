classdef Image < handle
%Abstract Image class, reference for more specialized implementations
%   
%   Example
%   
%   See also
%   Image2D, Image3D
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
    
    % Size of data buffer(in x,y,z,c,t order)
    dataSize    = [];
        
    % Spatial calibration of image.
    calib;
    
    % Image name, empty by default
    name        = '';
end

%% Static methods
methods (Static)
    img = create(varargin)
    
    img = read(fileName, varargin)
    
end % static methods


%% Private Static methods
methods (Static, Access = protected)
    info = metaImageInfo(fileName)
    img = metaImageRead(info)
end % static methods


%% Constructor declaration
methods (Access = protected)
    function this = Image(varargin)
        %IMAGE Constructor for Image object.
        
        if nargin==0
            % empty constructor
            % (nothing to do !)
        elseif isa(varargin{1}, 'Image')
            disp('called copy constructor of Image class');
            % copy constructor
            img = varargin{1};
            varargin(1) = [];
            this.data       = img.data;
            this.dataSize   = img.dataSize;

            % update private fields
            this.copyFields(img);

        else
            % first argument is either the data buffer, or the image dim
            if isscalar(varargin{1})
                nd = varargin{1};
                this.dataSize = ones(1, nd);
            else
                % initialize data buffer and image size
                setInnerData(varargin{1});
            end
            varargin(1) = [];
            
            % update other data depending in image size.
            nd = length(this.dataSize);
            this.calib  = SpatialCalibration(nd);
        end
        
        % assumes there are pairs of param-values
        while length(varargin)>1
            varName = varargin{1};
            value = varargin{2};
            
            switch varName
                case 'data'
                    setInnerData(value);
                case 'parent'
                    this.copyFields(value);
                case 'name'
                    this.name = value;
                case 'origin'
                    this.setOrigin(value);
                case 'spacing'
                    this.setSpacing(value);
                otherwise
                    error(['Unknown parameter name: ' varName]);
            end
            
            varargin(1:2) = [];
        end
        
        
        function setInnerData(data)
            % helper function that initialize data buffer and its size
            this.data = data;
            
            siz = size(this.data);
            this.dataSize = siz;            
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
    end
    
    function setInnerData(this, data)
        % Initialize data buffer and computes its size
        this.data = data;
        this.dataSize = size(this.data);
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
