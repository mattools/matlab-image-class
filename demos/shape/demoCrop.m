% Demonstration of image crop functions
%
%   output = demoCrop(input)
%
%   Example
%   demoCrop
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2022-06-24,    using Matlab 9.12.0.1884302 (R2022a)
% Copyright 2022 INRAE.

%% Input data

% read sample image
% (provided within the @image/sampleFiles directory)
img = Image.read('wheatGrainSlice.tif');

figure; show(img);


%% Boxes

% need to segment image to obtain the region of the grain
seg = img > 160;
seg2 = areaOpening(killBorders(seg), 10);

% compute boxes
box = regionBoundingBox(seg2);
obox = regionOrientedBox(seg2);

% display boxes over image
% (requires MatGeom toolbox)
hold on; 
drawBox(box, 'color', 'g', 'linewidth', 2);
drawOrientedBox(obox, 'color', 'm', 'linewidth', 2);


%% Crop 

resCrop = crop(img, box);
figure; show(resCrop)
title('Crop Box');
write(resCrop, 'wheatGrainCrop.tif');

resCrop2 = cropOrientedBox(img, obox);
figure; show(resCrop2)
title('Crop Oriented Box');
write(resCrop, 'wheatGrainCropOriented.tif');

