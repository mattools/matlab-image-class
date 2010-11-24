function [res grad] = evaluate(this, params)
%EVALUATE Evaluate value and metric of MSD image to image metric
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
% Created: 2010-10-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

this.transform.setParameters(params);

if nargout>1
    [res grad] = this.computeValueAndGradient();
else
    res = this.computeValue();
end
