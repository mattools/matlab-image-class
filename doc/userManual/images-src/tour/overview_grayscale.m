%OVERVIEW_GRAYSCALE  One-line description here, please.
%
%   output = overview_grayscale(input)
%
%   Example
%   overview_grayscale
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-08-22,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - Cepia Software Platform.

% read and display image
img = Image.read('cameraman.tif');
figure; show(img);
print(gcf, 'cameraman-show.png', '-dpng');

% show histogram
figure; histogram(img);
print(gcf, 'cameraman-histogram.png', '-dpng');

% plot horizontal line profile in the middle of image
lineProfile(img, [10 125], [250 125]);
print(gcf, 'cameraman-lineProfile.png', '-dpng');
