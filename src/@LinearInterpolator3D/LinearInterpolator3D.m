classdef LinearInterpolator3D < ImageInterpolator3D
%LINEARINTERPOLATOR3D  Linear interpolator of an image
%   INTERP = LinearInterpolator3D(IMG)
%
%   Example
%   
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-01-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Constructors
methods
    function this = LinearInterpolator3D(varargin)
        % Constructs a new LinearInterpolator object.
        % interp = LinearInterpolator(IMG);
        % with IMG being a Image2D.
        
        % process input arguments
        if isa(varargin{1}, 'LinearInterpolator3D')
            % copy constructor
            var = varargin{1};
            img = var.image;
        elseif isa(varargin{1}, 'Image')
            % copy constructor
            img = varargin{1};
        else
            error('Wrong parameter when constructing a 3D linear interpolator');
        end

        % call superclass constructor
        this = this@ImageInterpolator3D(img);

    end % constructor declaration    
end % methods

end % classdef