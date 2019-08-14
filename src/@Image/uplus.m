function res = uplus(obj)
% Overload the uplus operator for Image objects.
%
%   RES = uplus(IMG)
%
%   Example
%   uplus
%
%   See also
%     uminus
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-11-28,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = builtin('uplus', obj.Data);
res = Image('data', newData, 'parent', obj);
