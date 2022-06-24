function res = cropOrientedBox(obj, obox, varargin)
% Crop the content of an image within an oriented box.
%
%   RES = cropOrientedBox(IMG, OBOX)
%   Crops the content of the image IMG that is contained within the
%   oriented box OBOX. The size of the resulting image is approximately
%   (due to rounding) the size of the oriented box.
%
%   Example
%     % open and display input image
%     img = Image.read('circles.png') ;
%     figure; show(img); hold on;
%     % identifies oriented box around the main region
%     obox = regionOrientedBox(img > 0);
%     drawOrientedBox(obox, 'g');
%     % crop the content of the oriented box
%     res = cropOrientedBox(img, obox);
%     figure; show(res)
%
%   See also
%     regionOrientedBox, crop
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2022-06-24,    using Matlab 9.12.0.1884302 (R2022a)
% Copyright 2022 INRAE.

% retrieve oriented box parameters
boxCenter = obox(1:2);
boxSize = obox(3:4);
boxAngle = obox(5);

% create the transform matrix that maps from box coords to global coords
transfo = createTranslation(boxCenter) * createRotation(deg2rad(boxAngle));

% sample points within the box (use single pixel spacing)
lx = -floor(boxSize(1)/2):ceil(boxSize(1)/2);
ly = -floor(boxSize(2)/2):ceil(boxSize(2)/2);

% map into global coordinate space
[y, x] = meshgrid(ly, lx);
[x, y] = transformPoint(x, y, transfo);

% evaluate within image, keeping type of original image
resData = zeros(size(x), class(obj.Data));
resData(:) = interp(obj, x, y);

% create new image
res = Image('data', resData, 'parent', obj);
