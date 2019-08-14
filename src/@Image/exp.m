function res = exp(obj)
% Overload the exp operator for image object.
%
%   RES = exp(IMG)
%
%   Example
%   exp
%
%   See also
%     log, log10

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = exp(double(obj.Data));

res = Image('data', newData, 'parent', obj, 'type', 'intensity');
