%OVERVIEW_SEGMENTRICEGRAINS  One-line description here, please.
%
%   output = overview_segmentRiceGrains(input)
%
%   Example
%   overview_segmentRiceGrains
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

%% Manual segmentation

segManual = img > 80;
write(uint8(segManual) * 255, 'coins-segMan.png', 'png');
ovrManual = overlay(img, segManual, 'r');
write(ovrManual, 'coins-segMan-ovr.png', 'png');


%% segment using Otsu
segOtsu = otsuThreshold(img);
figure; show(segOtsu);
ovrOtsu = overlay(img, segOtsu, 'r');
write(ovrOtsu, 'coins-segOtsu-ovr.png', 'png');
ovrBndOtsu = overlay(img, boundary(segOtsu), 'g');
write(ovrBndOtsu, 'coins-segOtsu-bnd-ovr.png', 'png');

%% segment using watershed on Gradient image
grad = norm(gradient(img));
gradf = boxFilter(grad, [5 5]);
emin = extendedMinima(gradf, 20, 4);
grad2 = imposeMinima(gradf, emin, 4);
wat = watershed(grad2, 4);
ovrWat = overlay(img, wat==0, 'g');
write(ovrWat, 'coins-segWat-ovr.png', 'png');

rgb = label2rgb(wat, 'jet', 'w');
figure; show(rgb);
write(rgb, 'coins-segWat-rgb.png', 'png');