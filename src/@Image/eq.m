function res = eq(this, arg)
%EQ Overload the eq operator for Image objects
%
%   output = eq(input)
%
%   Example
%   eq
%
%   See also
%
%
% ------
% Author: David legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isa(arg, 'Image')
    arg = arg.data;
end

newData = bsxfun(@eq, this.data, arg);

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this, 'type', 'binary');
