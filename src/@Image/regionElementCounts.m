function [counts, labels] = regionElementCounts(obj, varargin)
% Count the number of pixels/voxels within each region of a label image.
%
%   CNT = regionElementCounts(LBL)
%   For each region on the label image LBL, count the number of elements
%   (pixels or voxels) that constitute this region. Return a column vector
%   with as many elements as the number of regions.
%
%   [CNT, LABELS] = regionElementCounts(LBL)
%   Also returns the labels of the regions.
%
%   Example
%     img = Image.read('coins.png');
%     bin = fillHoles(img > 100);
%     lbl = componentLabeling(bin);
%     regionElementCounts(lbl)'
%     ans =
%       2563   1899   2598   1840   2693   1906   2648   2725   1935   2796
%
%   See also
%     regionCentroids, findRegionLabels, largestRegion
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-12-02,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.

% check input type
if ~isLabelImage(obj)
    error('Requires a label image as input');
end

% determine labels
if isempty(varargin)
    labels = unique(obj.Data(:));
    labels(labels==0) = [];
else
    labels = varargin{1};
end

% rely on regionprops for speed
if size(obj.Data, 3) == 1
    props = regionprops(obj.Data, 'Area');
    counts = [props.Area]';
    counts = counts(labels);
else
    props = regionprops3(obj.Data, 'Volume');
    counts = [props.Volume];
    counts = counts(labels);
end
    