function res = uminus(this)
%UMINUS Overload the uminus operator for Image objects
%
%   output = uminus(input)
%
%   Example
%   uminus
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = builtin(@uminus, this.data);

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this);
