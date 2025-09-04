%PROCESSMAIZECROP  One-line description here, please.
%
%   output = processMaizeCrop(input)
%
%   Example
%   processMaizeCrop
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-02-18,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE.

img = Image.read('A01bis_crop.tif');

imgO = opening(img, strel('disk', 5));
write(imgO, 'A01cropO.png');

imgOC = closing(imgO, strel('disk', 10));
write(imgOC, 'A01cropOC.png');

seg = otsuThreshold(imgOC);
write(seg, 'A01cropOCseg.png');

seg2 = areaOpening(seg, 1000);
write(seg2, 'A01cropOCseg2.png');

ovr = overlay(img, dilation(boundary(seg2), strel('disk', 4)));
write(ovr, 'A01cropOCsegOvr.png');

figure; show(ovr)