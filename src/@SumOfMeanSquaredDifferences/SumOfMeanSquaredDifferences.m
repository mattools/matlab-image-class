classdef SumOfMeanSquaredDifferences < ImageSetMetric
%SUMOFMEANSQUAREDDIFFERENCES Compute the sum of MSD for all image couples
%
%   output = SumOfMeanSquaredDifferences(input)
%
%   Example
%   SumOfMeanSquaredDifferences
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-09-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Constructor
methods
    function this = SumOfMeanSquaredDifferences(varargin)
        % calls the parent constructor
        this = this@ImageSetMetric(varargin{:});
        
    end % constructor
    
end % methods

end % classdef
