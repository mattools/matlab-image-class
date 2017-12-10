function res = mpower(this, arg)
%MPOWER Overload the mpower operator for image object
%
%   output = mpower(input)
%
%   Example
%   mpower
%
%   See also
% 

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isa(arg, 'Image')
    arg = arg.data;
end

newData = bsxfun(@power, double(this.data), arg);

res = Image('data', newData, 'parent', this, 'type', 'intensity');
