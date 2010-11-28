function res = ge(this, arg)
%GE Overload the ge operator for Image objects
%
%   output = ge(input)
%
%   Example
%   ge
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isa(arg, 'Image')
    arg = arg.data;
end

newData = bsxfun(@ge, this.data, arg);

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this);
