function [boxes, labels] = regionBoxes(obj, varargin)
% Bounding box of regions within a 2D or 3D binary or label image.
%
%   BOX = regionBoxes(IMG)
%   Compute the bounding boxes of the regions within the label image IMG.
%   If the image is binary, a single box corresponding to the foreground
%   (i.e. the pixels with value 1) is computed.
%
%   The result is a N-by-4 array BOX = [XMIN XMAX YMIN YMAX], containing
%   coordinates of the box extent.
%
%   The same result could be obtained with the regionprops function. The
%   advantage of using regionBoxes is that equivalent boxes can be
%   obtained in one call. 
%
%   BOX = regionBoxes(IMG3D)
%   If input image is a 3D array, the result is a N-by-6 array, containing
%   the maximal coordinates in the X, Y and Z directions:
%   BOX = [XMIN XMAX YMIN YMAX ZMIN ZMAX].
%
%   [BOX, LABELS] = regionBoxes(...)
%   Also returns the labels of the regions for which a bounding box was
%   computed. LABELS is a N-by-1 array with as many rows as BOX.
%
%   [...] = regionBoxes(IMG, LABELS)
%   Specifies the labels of the regions whose bounding box need to be
%   computed.
%
%
%   Example
%     % Compute bounding box of coins regions
%     img = Image.read('coins.png');            % read image
%     bin = opening(img > 80, ones([3 3]));     % binarize
%     lbl = componentLabeling(bin);             % compute labels
%     figure; show(img);                        % display image
%     boxes = regionBoxes(lbl);                 % compute bounding boxes
%     hold on; drawBox(boxes, 'b');             % display boxes
%
%   See also
%     drawBox, regionCentroids
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-02-02,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE.

% check image type
if ~(isLabelImage(obj) || isBinaryImage(obj))
    error('Requires a label of binary image');
end

% check if labels are specified
labels = [];
if ~isempty(varargin) && isnumeric(varargin{1}) && size(varargin{1}, 2) == 1
    labels = varargin{1};
end

% extract the set of labels, without the background
if isempty(labels)
    labels = findRegionLabels(obj);
end

% switch processing depending on dimension
nd = ndims(obj);
if nd == 2
    %% Process planar case 
    props = regionprops(obj.Data, 'BoundingBox');
    props = props(labels);
    bb = reshape([props.BoundingBox], [4 length(props)])';
    
    % convert to (x,y) indexing convention
    boxes = [bb(:, 2) bb(:, 2)+bb(:, 4) bb(:, 1) bb(:, 1)+bb(:, 3)];
    
    % spatial calibration
    if isCalibrated(obj)
        spacing2 = obj.Spacing([1 1 2 2]);
        origin2 = obj.Origin([1 1 2 2]);
        boxes = bsxfun(@plus, bsxfun(@times, (boxes - 1), spacing2), origin2);
    end
    
elseif nd == 3
    %% Process 3D case
    props = regionprops3(obj.Data, 'BoundingBox');
    props = props(labels);
    bb = reshape([props.BoundingBox], [6 size(props, 1)])';
    bb = bb(labels, :);

    % convert to (x,y,z) indexing convention
    boxes = [bb(:, 2) bb(:, 2)+bb(:, 5) bb(:, 1) bb(:, 1)+bb(:, 4) bb(:, 3) bb(:, 3)+bb(:, 6)];
   
    % spatial calibration
    if isCalibrated(obj)
        spacing2 = obj.Spacing([1 1 2 2 3 3]);
        origin2 = obj.Origin([1 1 2 2 3 3]);
        boxes = bsxfun(@plus, bsxfun(@times, (boxes - 1), spacing2), origin2);
    end
else
    error('Image dimension must be 2 or 3');
end
