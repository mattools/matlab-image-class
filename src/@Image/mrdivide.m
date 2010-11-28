function res = mrdivide(this, arg)
%MRDIVIDE Overload the mrdivide operator for image object
%
%   output = mrdivide(input)
%
%   Example
%   mrdivide
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

newData = bsxfun(@rdivide, this.data, arg);

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this);
