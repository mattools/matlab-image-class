function res = invert(this)
%INVERT Invert an image (computes its complement)
%
%   output = invert(input)
%
%   Example
%   invert
%
%   See also
%   imcomplement
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

res = Image('data', imcomplement(this.data), 'parent', this);
