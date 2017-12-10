%DEMOGRADIENT Compute gradient on a planar image
%
%   output = demoGradient(input)
%
%   Example
%   demoGradient
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-09-29,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.

%% Read image, and compute norm of gradient

img = Image.read('coins.png');

% display original image
figure; 
show(img); 
title('original image');

% compute gradient, using default options
G = gradient(img);
GNorm = norm(G);

% display norm of gradient
figure; 
show(GNorm); 
title('norm of gradient image');


%% Display gradient components

% Extract gradient components
GX = channel(G, 1);
GY = channel(G, 2);

% display normalized components
figure; show(GX, [-50 50]);
title('Gradient X');
figure; show(GY, [-50 50]);
title('Gradient Y');


%% Display orientation weighted by norm

% compute orientation (between -pi and +pi)
ang = angle(G);

% create HSV image representing gradient
hue = (ang / (2*pi) + .5);
val = GNorm / max(GNorm(:));
sat = Image.ones(size(img), 'double');

% convert to RGB for display
hsv = cat(4, hue, sat, val); % channel index for Image class is 4.
rgb = hsv2rgb(hsv);

% display gradient orientation
figure;
show(rgb);
title('Gradient orientation');