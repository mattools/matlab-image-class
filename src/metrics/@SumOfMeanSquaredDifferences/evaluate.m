function [res grad] = evaluate(this, params)
%EVALUATE  One-line description here, please.
%
%   output = evaluate(input)
%
%   Example
%   evaluate
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-23,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% Setup the parameters of the object

% number of parameters
nFP = length(params);

% number of transforms
nF = length(this.transforms);

% number of parameter by transform
nP = nFP/nF;

% update each transform
for i=1:nF
    par = params((i-1)*nP+1:i*nP);
    transfo = this.transforms{i};
    transfo.setParameters(par);
end


% compute the value
if nargout<=1
    res = computeValue(this);
else
    [res grad] = computeValueAndGradient(this);
end
