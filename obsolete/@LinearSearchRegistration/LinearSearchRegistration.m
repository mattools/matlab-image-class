classdef LinearSearchRegistration < ImageToImageRegistration
%LINEARSEARCHREGISTRATION Implementation of linear search registration
%
%   output = LinearSearchRegistration(input)
%
%   Example
%   LinearSearchRegistration
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% some properties specific to Gradient-descent registration
properties
    % set of directions, with as many columns as the number of parameters
    directionSet;
    
    % max number of iterations
    nIter = 20;
    
    % verbosity
    verbose = true;
    
end % properties

%% Constructors
methods
    function this = LinearSearchRegistration(varargin)
    end
end % methods


%% Private methods
methods (Access = private)
    function checkFieldsInitialization(this)
        % Check that all required fields have been initialized
        
        if isempty(this.img1)
            error('Requires initialisation of fixed image');
        end
        if isempty(this.points)
            error('Requires initialisation of test points');
        end
        if isempty(this.transfo)
            error('Requires initialisation of parametric transform');
        end
        
        if isempty(this.tmi) && isempty(this.img2);
            error('Requires initialisation of moving image');
        end
        if isempty(this.tmi)
            this.tmi = BackwardTransformedImage(this.img2, this.transfo);
        end
       
   end
   
end % private methods

end % classdef
