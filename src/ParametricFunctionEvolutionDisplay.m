classdef ParametricFunctionEvolutionDisplay < OptimizationListener
%PARAMETRICFUNCTIONEVOLUTIONDISPLAY Displays evolution of a parametric function
%
%   output = ParametricFunctionEvolutionDisplay(input)
%
%   Example
%   ParametricFunctionEvolutionDisplay
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
    
    parametricFunction;
    
    valueArray;
    
    axisTitle = '';
end

methods
    function this = ParametricFunctionEvolutionDisplay(varargin)
        
        if nargin<2
            error('Need at least two input arguments');
        end
        
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

        this.parametricFunction = varargin{2};
        
        if nargin > 2
            this.axisTitle = varargin{3};
        end
        
    end % end constructor
    
end

methods
    function optimizationStarted(this, src, event) %#ok<*INUSD>
        
        % Initialize the parameter array
        this.valueArray = src.value;
    end
    
    function optimizationIterated(this, src, event)
        
        
        % compute current value of the function
        value = this.parametricFunction.computeValue();
        
        % append current value to the value array
        this.valueArray = [this.valueArray; value];
        
        % display current list of values
        nv = length(this.valueArray);
        plot(this.axisHandle, 1:nv, this.valueArray);
        set(this.axisHandle, 'xlim', [0 nv]);
        
        % decorate
        if ~isempty(this.axisTitle)
            title(this.axisHandle, this.axisTitle);
        end
        
        % refresh display
        drawnow expose;
    end
    
end

end
