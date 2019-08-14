function res = uminus(obj)
% Overload the uminus operator for Image objects.
%
%   RES = uminus(IMG)
%
%   Example
%   uminus
%
%   See also
%     uplus
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = builtin('uminus', obj.Data);
res = Image('data', newData, 'parent', obj);
