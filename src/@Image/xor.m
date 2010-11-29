function res = xor(this, arg)
%XOR Overload the xor operator for Image objects
%
%   output = xor(input)
%
%   Example
%   xor
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if ~islogical(this.data)
    error('Requires a binary image to work');
end

if isa(arg, 'Image')
    arg = arg.data;
end

if ~islogical(arg)
    error('Requires a binary argument to work');
end

newData = builtin('xor', this.data, arg);

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this);
