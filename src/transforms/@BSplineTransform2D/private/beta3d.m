function b = beta3d(x)
%BETA3D Derivative of a cubic spline
%
%   output = beta3d(input)
%
%   Example
%   beta3d
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-01-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

b = zeros(size(x));

ax = abs(x);

ind = ax<=1;
b(ind) = -2*x(ind) + x(ind).*ax(ind)*3/2;

ind = ax<=2 & ax>1;
%b(ind) = (-3*x(ind).*ax(ind) + 12*x(ind) - 12*sign(x(ind))) / 6;
b(ind) = (-3*ax(ind).^2 + 12*ax(ind) - 12).*sign(x(ind)) / 6;
