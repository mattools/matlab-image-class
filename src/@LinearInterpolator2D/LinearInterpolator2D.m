classdef LinearInterpolator2D < ImageInterpolator2D
%LINEARINTERPOLATOR2D  Linear interpolator of a 2D image
%   output = LinearInterpolator2D(input)
%
%   Example
%   I = Image2D('rice.png');
%   interp = LinearInterpolator2D(I);
%   val00 = I.getPixel(10, 10);
%   val01 = I.getPixel(11, 10);
%   val10 = I.getPixel(10, 11);
%   val11 = I.getPixel(11, 11);
%   valInt = interp.evaluate([10.5 10.5]);
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
    function this = LinearInterpolator2D(varargin)
        % Constructs a new LinearInterpolator2D object.
        % interp = LinearInterpolator(IMG);
        % with IMG being a Image2D.
        
        if isa(varargin{1}, 'LinearInterpolator2D')
            % copy constructor
            var = varargin{1};
            img = var.image;
        elseif isa(varargin{1}, 'Image2D')
            % copy constructor
            img = varargin{1};
        else
            error('Wrong parameter when constructing a linear interpolator');
        end
        
        this = this@ImageInterpolator2D(img);
    end % constructor declaration    
end % methods

end % classdef
