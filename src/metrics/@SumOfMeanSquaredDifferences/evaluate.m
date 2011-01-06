function varargout = evaluate(this, params)
%EVALUATE Evaluate the value and eventually the gradient of the function
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
% Created: 2011-01-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% number of images
nImg = length(this.images);

% ensure we have initialized transformed images and gradients
if length(this.transformedImages)~=nImg
    createTransformedImages(this);
end
if length(this.transformedGradients)~=nImg
    createTransformedGradients(this);
end

% update transform parameters
ind1 = 1;
for i=1:nImg
    % number of parameters of current transform
    transfo = this.transforms{i};
    nParams = transfo.getParameterLength();
    
    % extract parameters corresponding to current transform
    ind2 = ind1 + nParams-1;
    transfoParams = params(ind1:ind2);
    transfo.setParameters(transfoParams);
    
    % update for next transform
    ind1 = ind2 + 1;
end

% compute metric value and eventually gradient
if nargout <= 1
    varargout = {computeValue(this)};
else
    [fval grad] = computeValueAndGradient(this);
    varargout = {fval, grad};
end
