function res = plus(this, arg)
%PLUS Overload the plus operator for image object
%
%   output = plus(input)
%
%   Example
%   plus
%
%   See also
% 
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isa(arg, 'Image')
    arg = arg.data;
end

newData = bsxfun(@plus, this.data, cast(arg, class(this.data)));

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this);
