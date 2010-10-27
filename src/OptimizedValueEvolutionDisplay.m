classdef OptimizedValueEvolutionDisplay < OptimizationListener
%OPTIMIZEDVALUEEVOLUTIONDISPLAY Displays evolution of optimized value
%
%   output = OptimizedValueEvolutionDisplay(input)
%
%   Example
%   OptimizedValueEvolutionDisplay
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    axisHandle;
    
    valueArray;
    
    axisTitle = '';
end

methods
    function this = OptimizedValueEvolutionDisplay(varargin)
        
        % Initialize axis handle
        if ~isempty(varargin)
            var = varargin{1};
            if ~ishandle(var)
                error('First argument must be an axes handle');
            end
            
            if strcmp(get(var, 'Type'), 'axes')
                this.axisHandle = var;
            else
                this.axisHandle = gca;
            end
        else
            this.axisHandle = gcf;
        end
        
        if nargin > 1
            this.axisTitle = varargin{2};
        end
                
    end % end constructor
    
end

methods
    function optimizationStarted(this, src, event) %#ok<*INUSD>
        % Initialize the parameter array
        this.valueArray = src.value;
    end
    
    function optimizationIterated(this, src, event)
        
        % 
        % append current value to the value array
        this.valueArray = [this.valueArray; src.value];
        
        % display current list of values
        plot(this.axisHandle, this.valueArray);
        
        % decorate
        if ~isempty(this.axisTitle)
            title(this.axisHandle, this.axisTitle);
        end
    end
    
end

end
