function [area, labels] = regionArea(obj, varargin)
% Area of regions within a 2D binary or label image.
%
%   A = regionArea(IMG);
%   Compute the area of the regions in the image IMG. IMG can be either a
%   binary image, or a label image. If IMG is binary, a single area is
%   returned. In the case of a label image, the area of each region is 
%   returned in a column vector with as many elements as the number of
%   regions.
%
%   A = regionArea(..., LABELS);
%   In the case of a label image, specifies the labels for which the area
%   need to be computed.
%
%   Example
%     img = Image.read('rice.png');
%     img2 = img - opening(img, ones(30, 30));
%     lbl = componentLabeling(img2 > 50, 4);
%     areas = regionArea(lbl);
%
%   See Also
%     regionprops, regionPerimeter, regionEulerNumber, regionElementCount
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-11-02,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE.

% check image type
if ~(isLabelImage(obj) || isBinaryImage(obj))
    error('Requires a label of binary image');
end

% check dimensionality
nd = ndims(obj);
if nd ~= 2
    error('Requires a 2-dimensional image');
end

% check if labels are specified
labels = [];
if ~isempty(varargin) && size(varargin{1}, 2) == 1
    labels = varargin{1};
end

% extract the set of labels, without the background
if isempty(labels)
    labels = findRegionLabels(obj);
end

pixelCounts = regionElementCount(obj, labels);
area = pixelCounts * prod(obj.Spacing(1:2));
