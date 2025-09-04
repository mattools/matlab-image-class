%DEMOGRADIENTFILTER_RICE  One-line description here, please.
%
%   output = demoGradientFilter_rice(input)
%
%   Example
%   demoGradientFilter_rice
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-08-08,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

img = Image.read('rice.png');
grad = norm(gradient(img));
figure; show(grad, []);
[gx, gy] = gradient(img);
figure; subplot(121); show(gx,[]); subplot(122); show(gy,[]);

write(uint8(grad*5), 'rice_gradientNorm.png');

gx8 = uint8((gx * 4 + 128));
write(gx8, 'rice_gradientX.png');

gy8 = uint8((gy * 4 + 128));
write(gy8, 'rice_gradientY.png');
