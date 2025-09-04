%DEMO_BINARY_IMAGES  One-line description here, please.
%
%   output = demo_binary_images(input)
%
%   Example
%   demo_binary_images
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-01-14,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE.


%% Distance map

img = Image.read('circles.png');

distmap = distanceMap(img);
figure; show(distmap); colormap parula;

% convert to RGB
distmap(~img) = NaN;
distmapRGB = double2rgb(distmap, 'parula', [], 'w');

write(distmapRGB, 'circles-distmap-rgb.png', 'png');


%% Skeleton

ovr = overlay(img, skeleton(img));

write(ovr, 'circles-skeleton-ovr.png', 'png');


%% Boundary

bnd = boundary(img);
ovr = overlay(img, dilation(bnd, ones(3,3)), 'r');
write(ovr, 'circles-boundary-ovr.png', 'png');


%% Geodesic distance map

% create marker image
marker = Image.false(size(img));
marker(80, 80) = 1;

% save image of marker
markerV = dilation(marker, ones([3 7]));
markerH = dilation(marker, ones([7 3]));
crossMarker = markerV | markerH;
ovr = overlay(img, crossMarker, 'r');
write(ovr, 'circles-markerOvr.png', 'png');

% compute using quasi-enclidean weights
distMap = geodesicDistanceMap(marker, img);
rgb = double2rgb(distMap, 'parula', [], 'w');
rgb = overlay(rgb, crossMarker, 'r');
      
write(rgb, 'circles-geodDistMap.png', 'png');
