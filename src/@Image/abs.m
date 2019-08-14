function res = abs(obj)
% Overload the abs operator for image objects.
%
%   RES = abs(IMG)
%
%   Example
%   abs
%
%   See also
%     absdiff
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

res = Image('data', abs(obj.Data), 'parent', obj);
