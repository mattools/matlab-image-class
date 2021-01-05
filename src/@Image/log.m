function res = log(obj)
% Overload the log operator for image object.
%
%   LOGIMG = log(IMG)
%
%   Example
%   log
%
%   See also
%     log2, log10, exp
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = log(double(obj.Data));

name = createNewName(obj, '%s-log');
res = Image('Data', newData, 'Parent', obj, 'Type', 'intensity', ...
    'Name', name);
