classdef ImageIterator2D < handle
%IMAGEITERATOR2D  One-line description here, please.
%   output = ImageIterator2D(input)
%
%   Example
%   ImageIterator2D
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-12-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2009 INRA - Cepia Software Platform.


%% Declaration of class properties
properties
    x = 0;
    xmax = 0;
    y = 0;
    ymax = 0;
    
end

methods
    %% Constructor declaration
    function this = ImageIterator2D(varargin)
        %Constructs a ImageIterator2D object from an Image2D
        if nargin~=1
            error('Constructor takes one argument');
        end
        
        if isa(varargin{1}, 'Image2D')
            % copy constructor
            var = varargin{1};
            
        else
            error('First argument should be an image');
        end
    end % constructor declaration

end % end methods

end % end class