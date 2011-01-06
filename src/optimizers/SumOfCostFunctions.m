classdef SumOfCostFunctions < CostFunction
%SUMOFCOSTFUNCTIONS Compute the sum of several cost functions
%
%   output = SumOfCostFunctions(input)
%
%   Example
%   SumOfCostFunctions
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-01-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    costFunctions;
end 

%% Constructor
methods
    function this = SumOfCostFunctions(varargin)
        % Construct a new cost function aggregator
        
        if ~isempty(varargin)
            var = varargin{1};
            if iscell(var)
                this.costFunctions = var;
            end
        end
        
    end % constructor 

end % construction function

%% General methods
methods
    function varargout = evaluate(this, params)
        % Evaluate each stored cost function and compute their sum
        %
        % Example
        % % create the object
        % SOCF = SumOfCostFunctions({CF1, CF2, CF3});
        % % evaluate only value
        % F = SOCF.evaluate(PARAMS);
        % % evaluate value and gradient
        % [F G] = SOCF.evaluate(PARAMS);
        
        nf = length(this.costFunctions);
        
        f = 0;
        if nargout<=1
            % iterate over cost functions
            for i=1:nf
                f = f + evaluate(this.costFunction{i}, params);
            end
            
            % format output arguments
            varargout = {f};
            
        elseif nargout==2
            % initialize gradient
            g = zeros(size(params));
            
            % iterate over cost functions
            for i=1:nf
                [fi gi] = evaluate(this.costFunction{i}, params);
                f = f + fi;
                g = g + gi;
            end

            % format output arguments
            varargout = {f, g};
        end
    end
end % general methods

end % classdef
