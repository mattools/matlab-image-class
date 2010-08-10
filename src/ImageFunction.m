classdef ImageFunction < handle
%IMAGEFUNCTION Represent any object that determines value from an image
%   
%   Serves as a base class for Interpolators.
%
%   See also
%   ImageInterpolator
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-04-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
end

%% Static methods
methods(Static)
end % static methods

%% Abstract methods
methods (Abstract)
    
    evaluate(varargin)
    % Evaluate at a given position and return a value
    
end % abstract methods

%% General methods
methods
    
    function res = resample(this, varargin)
        % Evaluates the function for a set of positions and create new image
        %
        % RES = this.resample(BASE_IMAGE);
        % Specify coordinates from a reference image
        %
        % RES = this.resample(LX, LY);
        % specify coordinate using two position vectors
        %
        
        assert (~isempty(varargin), 'Should specify at least one argument');

        sampler = ImageResampler(varargin{:});
        res = sampler.resample(this);
    end
    
end % general methods

end  % classdef