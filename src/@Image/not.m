function res = not(obj)
% Overload the not operator for Image objects.
%
%   NIMG = not(IMG)
%
%   Example
%   not
%
%   See also
%     eq, lt, gt
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if ~islogical(obj.Data)
    error('Requires a binary image to work');
end

newData = builtin('not', obj.Data);

res = Image('data', newData, 'parent', obj);
