function res = or(this, arg)
%OR Overload the or operator for Image objects
%
%   output = or(input)
%
%   Example
%   or
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

newData = builtin('or', this.data, arg);

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this);
