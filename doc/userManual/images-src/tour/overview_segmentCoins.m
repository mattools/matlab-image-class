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

img = Image.read('coins.png');

grad = norm(gradient(img));
gradf = boxFilter(grad, [5 5]);
figure; show(gradf, []);
write(adjustDynamic(gradf), 'coins-grad-filt.png', 'png');

emin = extendedMinima(gradf, 20, 4);
grad2 = imposeMinima(gradf, emin, 4);
wat = watershed(grad2, 4);

ovr = overlay(img, wat==0, 'g');
figure; show(ovr);
write(ovr, 'coins-segWat-ovr.png', 'png');

wat2 = killBorders(wat);
rgb = label2rgb(wat2, 'jet', 'w');
figure; show(rgb);
write(rgb, 'coins-segWat-rgb.png', 'png');

pts = centroid(wat2);
hold on; plot(pts(:,1), pts(:,2), 'k*')
print(gcf, 'coins-segWat-rgb-centroids.png', '-dong');