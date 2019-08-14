function res = mpower(obj, arg)
% Overload the mpower operator for image object.
%
%   output = mpower(input)
%
%   Example
%   mpower
%
%   See also
%     mrdivide, mtimes 
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isa(arg, 'Image')
    arg = arg.Data;
end

newData = bsxfun(@power, double(obj.Data), arg);

res = Image('data', newData, 'parent', obj, 'type', 'intensity');
