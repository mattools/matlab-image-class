classdef ParametersEvolutionDisplay < OptimizationListener
%PARAMETERSEVOLUTIONDISPLAY Displays evolution of optmization parameters
%
%   output = ParametersEvolutionDisplay(input)
%
%   Example
%   ParametersEvolutionDisplay
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
    figureHandle;
    
    plotMatrix;
    
    paramValues;
    
    labels;
end

methods
    function this = ParametersEvolutionDisplay(varargin)
        if nargin == 0
            this.figureHandle = gcf;
        else
            this.figureHandle = varargin{1};
        end
        
        if nargin > 1
            this.plotMatrix = varargin{2};
        else
            this.plotMatrix = [2 2];
        end
        
        if nargin > 2
            var = varargin{3};
            if isnumeric(var)
                this.labels = strtrim(cellstr(num2str((1:10)', 'Param %d')));
            elseif iscell(var)
                this.labels = var;
            else
                error('Can not process labels parameter');
            end
            
        else
            this.labels = '';
        end
        
    end % end constructor
    
end

methods
    function optimizationStarted(this, src, event) %#ok<*INUSD>
        % Initialize the parameter array
        params = src.getParameters();
        this.paramValues = params;
    end
    
    function optimizationIterated(this, src, event)
        
        % append current parameters to the parameter array
        params = src.getParameters();
        this.paramValues = [this.paramValues ; params];
        
        figure(this.figureHandle);
        nRows = this.plotMatrix(1);
        nCols = this.plotMatrix(2);
        nv = size(this.paramValues, 1);
        
        for i=1:length(params)
            subplot(nRows, nCols, i);
            plot(1:nv, this.paramValues(:, i));
            xlim([0 nv]);
            
            if ~isempty(this.labels)
                title(this.labels{i});
            end
        end
        drawnow;
    end
    
    function optimizationTerminated(this, src, event)
    end
    
end

end
