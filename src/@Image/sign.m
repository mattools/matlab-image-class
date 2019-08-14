function res = sign(obj)
% Overload the sign function for image object.
%
%    PM = sign(IMG)
%
%   Example
%   sign
%
%   See also
%     plus, minus, gt, lt
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

res = Image('data', sign(obj.Data), 'parent', obj);
