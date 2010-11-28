function res = mtimes(this, arg)
%mtimes Overload the mtimes operator for image object
%
%   output = mtimes(input)
%
%   Example
%   mtimes
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

newData = bsxfun(@times, this.data, arg);

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this);
