classdef ScalarImage < Image
%SCALARIMAGE Add methods specific to images containing scalar values
%
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-07,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Constructors
methods
    function this = ScalarImage(varargin)
        % Constructs a new ScalarImage object.
        
        % default dimension is 2
        nd = 2;
        
        if nargin==0
            % initialize with an empty 2D array
            varargin = {'data', []};
        elseif isa(varargin{1}, 'Image2D')
            % copy constructor: use parameter as parent for new image
            var = varargin{1};
            varargin = [...
                {'data', var.data} ...
                {'parent', var} ...
                varargin(2:end)]; 
        else
            var = varargin{1};
            if isnumeric(var)
                % first parameter is image dimension
                nd = var;
                varargin(1) = [];
            end
        end

        % call the parent constructor, possibly using some parameters
        this = this@Image(nd, varargin{:});
        
    end % constructor declaration
end

end % end of class

