function b = beta3(x)
%BETA3 Compute base BSpline function
%
%   Usage
%   b = beta3(x)
%
%   See also
%   beta3d
%

% allocate memory
b = zeros(size(x));
ax = abs(x);

% compute result for values around 0
ind = ax<=1;
b(ind) = -ax(ind).^2 + ax(ind).^3/2 + 2/3;

% compute result for values outside
ind = ax<=2 & ax>1;
b(ind) = (2 - ax(ind)).^3 / 6;

