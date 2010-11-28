function res = uplus(this)
%UPLUS Overload the uplus operator for Image objects
%
%   output = uplus(input)
%
%   Example
%   uplus
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = builtin(@uplus, this.data);

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this);
