classdef OptimizationListener < handle
%OPTIMIZERLISTENER Base class for listening to Optimization events
%
%   output = OptimizationListener(input)
%
%   Example
%   OptimizationListener
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Constructor
methods
    function this = OptimizationListener(varargin)
        % Default constructeur        
    end % end constructor
    
end

%% General methods
methods
    function optimizationStarted(this, src, event)        %#ok<*INUSD,*MANU>
        % Overload this function to handle the 'OptimizationStarted' event
    end
    
    function optimizationIterated(this, src, event)        
        % Overload this function to handle the 'OptimizationIterated' event
    end
    
    function optimizationTerminated(this, src, event)        
        % Overload this function to handle the 'OptimizationTerminated' event
    end
    
end % general methods

end % classdef
