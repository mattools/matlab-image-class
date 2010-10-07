function [params value] = startOptimization(this)
%STARTOPTIMIZATION  Run the optimizer, and return optimized parameters
%
%   output = startOptimization(input)
%
%   Example
%   startOptimization
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% some options
options = optimset(...
    'TolX', 1e-2, ...
    'MaxIter', this.nIter, ...
    'Display', 'iter');

% Setup the eventual output function
if ~isempty(this.outputFunction)
    options.OutputFcn = this.outputFunction;
end

% run the simplex optimizer, by calling Matlab optimisation function
tic;
[params value] = fminsearch(this.costFunction, this.params, options);
elapsedTime = toc;

% display some results
disp(sprintf('Elapsed time: %7.5f s', elapsedTime)); %#ok<DSPS>
disp('Optimized parameters: ');
disp(params);

this.params = params;
