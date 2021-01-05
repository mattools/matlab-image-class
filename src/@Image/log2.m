function res = log2(obj)
% Overload the log2 operator for image object.
%
%   LOGIMG = log2(IMG)
%
%   Example
%   log2
%
%   See also
%     log, log10, exp
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = log2(double(obj.Data));

name = createNewName(obj, '%s-log10');
res = Image('data', newData, 'parent', obj, 'type', 'intensity', 'Name', name);
