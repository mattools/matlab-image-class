%PEPPERS_KMEANS  One-line description here, please.
%
%   output = peppers_kmeans(input)
%
%   Example
%   peppers_kmeans
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-03-13,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE.

% read the data
img = Image.read('peppers.png');

% compute k-means classes
cls = kmeans(img, 6);

% display the classes with arbitrary colors
rgb = label2rgb(cls, 'jet', 'w');
write(rgb, 'peppers_kmeans6_classes.png');

% display the classes with average color of each region
[cls, centers] = kmeans(img, 6);
map = centers / 255; % average color of each class
rgb = label2rgb(cls, map);
write(rgb, 'peppers_kmeans6_averageColor.png');
