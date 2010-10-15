classdef SpatialCalibration < handle
%SPATIALCALIBRATION Spatial calibration of a 2D or 3D image
%
%   output = SpatialCalibration(input)
%
%   Example
%   SpatialCalibration
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Properties
properties
    % flag indicating whether the image has been calibrated or not
    calibrated = false;
    
    % the position of the first pixel/voxel
    origin;
    
    % the resolution of image in each spatial direction
    spacing;
    
    % the name of the spacing unit, empty by default
    unitName = '';
    
    % the name of each axis, stored in a cell array with ND elements
    axisNames = {};
end

%% Constructors
methods
    function this = SpatialCalibration(varargin)
        % Constructor for a new spatial calibration
        % 
        %   Usage
        %   CALIB = SpatialCalibration()
        %   Create a default 2D spatial calibration.
        %
        %   CALIB = SpatialCalibration(ND)
        %   Create a default spatial calibration, set the calibrated flag
        %   to FALSE.
        %
        %   CALIB = SpatialCalbration(SPACING);
        %   Sepcifies the pixel/voxel spacing. The dimension of CALIB is
        %   the number of elements in SPACING. The calibrated flag is set
        %   to TRUE.
        %
        %   CALIB = SpatialCalbration(SPACING, ORIGIN);
        %   Also specifies the position of the first pixel/voxel. Both
        %   SPACING and ORIGIN must have the same number of columns.
        %
        
        if nargin==0
            % create Default 2D calibration
            this.spacing    = [1 1];
            this.origin     = [0 0];
            
        elseif nargin==1
            var = varargin{1};
            if isa(var, 'SpatialCalibration')
                % Copy constructor: copy each field
                this.calibrated = var.calibrated;
                this.spacing    = var.spacing;
                this.origin     = var.origin;
                this.unitName   = var.unitName;
                
            elseif isscalar(var)
                % Create default ND calibratino
                this.spacing    = ones(1, var);
                this.origin     = zeros(1, var);                
            else
                % First argument is spacing
                this.spacing    = var;
                this.calibrated = true;
            end
            
        else
            % Setup all fields
            this.spacing        = varargin{1};
            this.origin         = varargin{2};
            this.calibrated     = true;
            
            if nargin>2
                this.unitName   = varargin{3};
            end
        end        
            
    end % main constructor
    
end % constructors

%% General methods
methods
    function b = isCalibrated(this)
        b = this.calibrated;
    end
    
    function setCalibrated(this, b)
        this.calibrated = b;
    end
    
    function name = getAxisName(this, axisNumber)
        % Return the name of the i-th axis of the image.
        name = '';
        if length(this.axisNames)>axisNumber
            name = this.axisNames{axisNumber};
        end
    end
end % general methods

end % classdef

