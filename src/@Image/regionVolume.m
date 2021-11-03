function [vol, labels] = regionVolume(obj, varargin)
% Volume of regions within a 3D binary or label image.
%
%   V = regionVolume(IMG);
%   Computes the volume of the region(s) within the image. IMG is either a
%   binary image, or a label image. In the case of a label image, the area
%   of each region is returned in a column vector with as many elements as
%   the number of labels.
%
%
%   Example
%     % compute the volume of a binary ball of radius 10
%     lx = 1:30; ly = 1:30; lz = 1:30;
%     [x, y, z] = meshgrid(lx, ly, lz);
%     img = Image(hypot(hypot(x - 15.12, y - 15.23), z - 15.34) < 40);
%     v = regionVolume(img)
%     v =
%         4187
%     % to be compared to (4 * pi * 10 ^ 3 / 3), approximately 4188.79
%
%   See also
%     regionSurfaceArea, regionEulerNumber, regionArea, regionElementCount
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
if nd ~= 3
    error('Requires a 3-dimensional image');
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

% count the number of elements, and multiply by voxel volume
pixelCounts = regionElementCount(obj, labels);
vol = pixelCounts * prod(obj.Spacing(1:3));
