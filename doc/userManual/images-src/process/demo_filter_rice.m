%DEMO_FILTER_RICE  One-line description here, please.
%
%   output = demo_filter_rice(input)
%
%   Example
%   demo_filter_rice
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-08-22,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - Cepia Software Platform.

img = Image.read('rice.png');

% box filter
imgBox = boxFilter(img, [5 5]);
write(imgBox, 'rice-boxFilter5x5.png', 'png');

% box filter
imgBox = boxFilter(img, [5 5]);
write(imgBox, 'rice-boxFilter5x5.png', 'png');

% gaussian filter
imgGauss = gaussianFilter(img, [5 5], 2);
write(imgGauss, 'rice-gaussFilter5x5s2.png', 'png');

% median
imgMed = medianFilter(img, ones([5 5]));
write(imgMed, 'rice-medFilter5x5.png', 'png');

