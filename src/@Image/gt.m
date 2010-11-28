function res = gt(this, arg)
%GT Overload the gt operator for Image objects
%
%   output = gt(input)
%
%   Example
%   gt
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

newData = bsxfun(@gt, this.data, arg);

nd = getDimension(this);
res = Image(nd, 'data', newData, 'parent', this);
