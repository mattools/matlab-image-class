%PROCESS_RICE  One-line description here, please.
%
%   output = process_rice(input)
%
%   Example
%   process_rice
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-02-18,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE.

img = Image.read('rice.png');

img2 = medianFilter(img, ones(3, 3));
write(img2, 'rice_med.tif');

img3 = whiteTopHat(img2, ones(30, 30));
write(img3, 'rice_med_WTH.tif');

img4 = otsuThreshold(img3);
write(img4, 'rice_med_WTH_otsu.tif');

img5 = ~img4;
img5(:, [1 end]) = false;
img5([1 end], :) = false;
write(img5, 'rice_med_WTH_otsuInvB.tif');

img6 = componentLabeling(img4, 4);
write(img6, 'rice_med_WTH_otsu_lbl.tif');

rgb = label2rgb(img6, 'jet', 'w', 'shuffle');
write(rgb, 'rice_med_WTH_otsu_lbl_rgb.tif');
