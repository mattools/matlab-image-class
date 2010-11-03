classdef WeightedSumOfFunctions < BaseFunction
%MULTIMETRICMANAGER A function that computes the sum of several functions
%
%   output = WeightedSumOfFunctions(input)
%
%   Example
%   WeightedSumOfFunctions
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Properties
properties
    % the set of functions
    functionSet;
    
    % weights associated to each function
    weights;
    
end
 
%% Constructor
methods
    function this = WeightedSumOfFunctions(varargin)
        
        % need 2 inputs
        if nargin<2
            error('Need 2 input arguments');
        end
        
        % check that each input is itself a ParametricFunction
        var = varargin{1};
        if ~iscell(var)
            error('Input must be a cell array of BaseFunction');
        end
        for i = 1:length(var)
            metric = var{i};
            if ~isa(metric, 'BaseFunction')
                error('WeightedSumOfFunctions:WrongClass', ...
                    'The element number %d is not a BaseFunction, but a %s', ...
                    i, class(metric));
            end
        end
        
        % stores the set of metrics
        this.functionSet = var;
        
        if nargin<2
            this.weights = ones(1, length(this.functionSet));
        else
            this.weights = varargin{2};
        end
        
    end % constructor
 
end % construction function
 
%% General methods
methods
 
    function value = computeValue(this)
        % Compute the sum of the values returned by each child function
        
        % initialize
        value = 0;
        
        % compute the sum
        for i=1:length(this.functionSet)
            fun = this.functionSet{i};
            w = this.weights(i);
            
            value = value + w * fun.computeValue();
        end        
    end
    
end % general methods
 
end % classdef

