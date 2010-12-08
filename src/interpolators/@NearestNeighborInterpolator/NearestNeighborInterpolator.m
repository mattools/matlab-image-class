classdef NearestNeighborInterpolator < ImageInterpolator
%NEARESTNEIGHBORINTERPOLATOR  Nearest-neighbor interpolator of an image
%
%   output = NearestNeighborInterpolator(IMG)
%
%   Example
%   I = Image.read('rice.png');
%   interp = NearestNeighborInterpolator(I);
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
    function this = NearestNeighborInterpolator(varargin)
        % Constructs a new NearestNeighborInterpolator object.
        % interp = LinearInterpolator(IMG);
        % with IMG being a Image2D.
        
        if isa(varargin{1}, 'NearestNeighborInterpolator')
            % copy constructor
            var = varargin{1};
            image = var.image;
        elseif isa(varargin{1}, 'Image')
            % initialisation constructor
            image = varargin{1};
                        
        else
            error('Wrong parameter when constructing a nearest neighbor interpolator');
        end
        
        % call superclass constructor
        this = this@ImageInterpolator(image);
        
    end % constructor declaration
    
end % methods

end % classdef