classdef ImageInterpolator3D < ImageInterpolator
%IMAGEINTERPOLATOR3D Abstract class that groups image interpolators
%   output = ImageInterpolator3D(input)
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-04-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

methods (Access = protected)
       function this = ImageInterpolator3D(image)
        % Constructs a new ImageInterpolator3D object.
        
        % call superclass constructor
        this = this@ImageInterpolator(image);

    end % constructor declaration    
end
    
end % classdef

