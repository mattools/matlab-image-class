function res = log10(obj)
% Overload the log10 operator for image object.
%
%   LOGIMG = log10(IMG)
%
%   Example
%   log10
%
%   See also
%     log, log2, exp
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = log10(double(obj.Data));

res = Image('data', newData, 'parent', obj, 'type', 'intensity');
