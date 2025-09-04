%OVERVIEW_RICEGRAINS  One-line description here, please.
%
%   output = overview_riceGrains(input)
%
%   Example
%   overview_riceGrains
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-08-22,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - Cepia Software Platform.

% read and explore data
img = Image.read('rice.png');
figure; show(img);
lineProfile(img, [128 1], [128 255]);

% filtering
img2 = medianFilter(img, ones([3 3]));
imgTop = whiteTopHat(img2, ones([30 30]));
figure; show(imgTop);

% segmentation
figure; histogram(imgTop);
bin = imgTop > 50;

% labeling
lbl = componentLabeling(bin);
lbl2 = killBorders(lbl);
rgb = label2rgb(lbl2);
figure; show(rgb);

% analysis
centers = centroid(lbl2);
figure; show(img); hold on;
plot(centers(:,1), centers(:,2), 'r+');

