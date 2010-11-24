classdef ImageInterpolator < ImageFunction
%IMAGEINTERPOLATOR Abstract class that groups image interpolators
%   output = ImageInterpolator(input)
%
%   Example
%   ImageInterpolator
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-04-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    % inner image
    image;
end

%% Static methods
methods(Static)
    function interp = create(img, type)
        % Create an image interpolator based on its name and and image.
        %
        % Valid types are:
        %   - 'nearest'
        %   - 'linear'
        %
        % Example:
        % img = Image2D(uint8(ones(20, 20)*255));
        % interp = ImageInterpolator.create(img, 'linear');
        %
        
        nd = length(img.getSize());
        
        if strcmpi(type, 'linear')            
            if nd==2
                interp = LinearInterpolator2D(img);
            elseif nd==3
                interp = LinearInterpolator3D(img);
            else
                error(['Could not create linear interpolator for image of dimension ' ...
                    num2str(nd)]);
            end
        elseif strcmpi(type, 'nearest')
                interp = NearestNeighborInterpolator2D(img);
                %TODO: should not be dim-specific
        else
            error('Unknown string for specifying interpolator');
        end
    end
end % static methods

methods  (Access = protected)
    function this = ImageInterpolator(image)
        % Construct a new ImageInterpolator object.
        
        this.image = image;
    end % constructor declaration
end

%% Abstract methods
methods (Abstract)
    evaluate(varargin)
    
    evaluateAtIndex(varargin)
    
end % abstract methods

%% General methods
methods
    function img = getImage(varargin)
        % Return the inner image of the interpolator
        img = this.img;
    end
    
    function d = getDimension(this)
        %GETDIMENSION  Dimension of the interpolated image
        %
        %   D = img.getDimension();
        %   Returns the dimension of the inner image
        d = this.image.getDimension();
    end
end

end  % classdef