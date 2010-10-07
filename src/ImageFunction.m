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
methods(Access=protected, Static)
    function [coords dim] = mergeCoordinates(varargin)
        %MERGECOORDINATES Merge all coordinates into a single N-by-2 array
        % 
        % [coords dim] = mergeCoordinates(X, Y)
        % [coords dim] = mergeCoordinates(X, Y, Z)
        %
        
        % case of coordinates already grouped
        coords = varargin{1};
        dim = [size(coords,1) 1];

        % If more than 1 argument, group all arrays
        if nargin>1
            dim = size(coords);
            nDims = length(varargin);
            coords = zeros(numel(coords), nDims);
            
            for i = 1:length(varargin)
                var = varargin{i};
                coords(:, i) = var(:);
            end
        end
    end
    
    function varargout = splitCoordinates(coords, dim)
        %SPLITCOORDINATES Split a coordinate array into a cell array
        % 
        % [X Y] = splitCoordinates(COORDS, DIM);
        % [X Y Z] = splitCoordinates(COORDS, DIM);
        %
        
        % number of dimensions
        nDims = length(dim);
        if nDims(end)==1
            nDims = 1;
        end
        
        % allocate memory
        varargout = cell(1, nDims);
        
        % compute each coordinate array
        for i=1:nDims
            varargout{i} = reshape(coords(:,i), dim);
        end
    end
    
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