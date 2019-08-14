function res = sqrt(obj)
% Overload the sqrt operator for image object.
%
%   RES = sqrt(IMG)
%
%   Example
%     img = Image.read('rice.png');
%     [gx, gy] = gradient(img);
%     gnorm = sqrt(gx*gx + gy*gy);
%
%   See also
%     hypot
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

newData = sqrt(double(obj.Data));

res = Image('data', newData, 'parent', obj);
