function res = le(this, arg)
%LE Overload the le operator for Image objects
%
%   output = le(input)
%
%   Example
%   le
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isa(arg, 'Imale')
    arg = arg.data;
end

newData = bsxfun(@le, this.data, arg);

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this, 'type', 'binary');
