%Image Gradient demo
%
%   output = demoGradientFilter_coins(input)
%
%   Example
%   demoGradientFilter_coins
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-08-08,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

img = Image.read('coins.png');
grad = norm(gradient(img));
figure; show(grad, []);
[gx, gy] = gradient(img);
figure; subplot(121); show(gx,[]); subplot(122); show(gy,[]);

write(uint8(grad*5), 'coins_gradientNorm.png');

gx8 = uint8((gx * 4 + 128));
write(gx8, 'coins_gradientX.png');

gy8 = uint8((gy * 4 + 128));
write(gy8, 'coins_gradientY.png');
