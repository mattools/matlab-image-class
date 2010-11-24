classdef NearestNeighborInterpolator3D < ImageInterpolator3D
%NearestNeighborInterpolator3D  Nearest-neighbor interpolator of a 3D image
%   output = NearestNeighborInterpolator3D(IMG)
%
%   Example
%   I = Image2D('rice.png');
%   interp = NearestNeighborInterpolator3D(I);
%   val1 = interp.evaluate([9.7 9.7]);
%   val2 = interp.evaluate([10.3 10.3]);
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
    function this = NearestNeighborInterpolator3D(varargin)
        % Constructs a new NearestNeighborInterpolator3D object.
        % interp = LinearInterpolator(IMG);
        % with IMG being a Image2D.
        
        if isa(varargin{1}, 'NearestNeighborInterpolator3D')
            % copy constructor
            var = varargin{1};
            image = var.image;
        elseif isa(varargin{1}, 'Image3D')
            % initialisation constructor
            image = varargin{1};
        else
            error('Wrong parameter when constructing a nearest neighbor interpolator');
        end
        
        % call superclass constructor
        this = this@ImageInterpolator3D(image);
        
    end % constructor declaration
    
end % methods

end % classdef