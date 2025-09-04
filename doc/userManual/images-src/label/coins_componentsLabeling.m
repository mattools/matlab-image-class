%COINS_COMPONENTSLABELING  One-line description here, please.
%
%   output = coins_componentsLabeling(input)
%
%   Example
%   coins_componentsLabeling
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-08-22,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - Cepia Software Platform.

% read data
img = Image.read('coins.png');

% binarise
bin = opening(img > 80, ones(3, 3));
write(invert(bin), 'coins-bin.png', 'png');

% compute labels
lbl = componentLabeling(bin);
lbl8 = adjustDynamic(lbl);
write(lbl8, 'coins-componentLabeling-gray8.png', 'png');

% create color image
rgb = label2rgb(lbl, 'jet', 'w');
write(rgb, 'coins-componentLabeling-rgb.png', 'png');

