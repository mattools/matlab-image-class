function [boxes, labels] = regionMinMaxIndices(obj, varargin)
% Bounding indices of regions within a label image, in pixel coordinates.
%
%   BI = regionMinMaxIndices(lbl);
%   Similar to the regionBoundingBox function, but do not take into account
%   spatial calibration of images.
%   Returns a set of start and end indices for each dimension and each
%   region.
%   BI = [INDXMIN INDXMAX INDYMIN INDYMAX]
%
%   The region within the imag can be cropped using:
%   img2 = img(BI(1,1):BI(1,2), BI(2,1):BI(2,2));
%
%   Example
%     % crop an image using the result of regionMinMaxIndices
%     img = Image.read('circles.png');
%     bi = regionMinMaxIndices(img);
%     img2 = img{bi(1):bi(2), bi(3):bi(4)};
%     figure;
%     show(img2)
%
%   See also
%     drawBox, regionBoundingBox
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-10-19,    using Matlab 9.8.0.1323502 (R2020a)
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
    
    % round start index
    bb(:,[1 2]) = ceil(bb(:,[1 2]));
    bb(:,[3 4]) = bb(:,[3 4]) - 1;
    
    % convert to (x,y) indexing convention
    boxes = [bb(:, 2) bb(:, 2)+bb(:, 4) bb(:, 1) bb(:, 1)+bb(:, 3)];
    
elseif nd == 3
    %% Process 3D case
    props = regionprops3(obj.Data, 'BoundingBox');
    props = props(labels);
    bb = reshape([props.BoundingBox], [6 size(props, 1)])';
    bb = bb(labels, :);

    % round start index
    bb(:,[1 2 3]) = ceil(bb(:,[1 2 3]));
    bb(:,[4 5 6]) = bb(:,[4 5 6]) - 1;
    
    % convert to (x,y,z) indexing convention
    boxes = [bb(:, 2) bb(:, 2)+bb(:, 5) bb(:, 1) bb(:, 1)+bb(:, 4) bb(:, 3) bb(:, 3)+bb(:, 6)];
    
else
    error('Image dimension must be 2 or 3');
end
