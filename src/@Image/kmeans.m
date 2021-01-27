function [res, centers] = kmeans(obj, k, varargin)
% Apply k-means clustering to a multi-channel image.
%
%   CLASSES = kmeans(IMG, K)
%   Compute kmeans clustering of the image IMG, using K classes. The result
%   is a label image with values ranging from 1 no K.
%
%   [CLASSES, CENTERS] = kmeans(IMG, K);
%   Also returns the coordinates of class centers. CENTERS is a K-by-NC
%   array, where NC is the number of channels of original image IMG.
%
%   Requires the statistics toolbox.
%
%   Example
%     % k-means segmentation of a RGB color image
%     img = Image.read('peppers.png');
%     cls = kmeans(img, 6);
%     % display the classes with arbitrary colors
%     rgb = label2rgb(cls, 'jet', 'w');
%     figure; show(rgb)
%     % display the classes with average color of each region
%     [cls, centers] = kmeans(img, 6);
%     map = centers / 255; % average color of each class
%     rgb = label2rgb(cls, map);
%     figure; show(rgb);
%
%     % multi-level segmentation of a grayscale image with k-means
%     nc = 5;
%     img = Image.read('cameraman.tif');
%     [classes, values] = kmeans(img, nc);
%     res = Image.zeros(size(img),'uint8');
%     for i = 1:nc
%         res(classes == i) = values(i);
%     end
%     figure; show(res);
%
%   See also
%     label2rgb, fold
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-01-15,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE.

% convert image content into nr-by-nc array
nr = elementCount(obj);
nc = channelCount(obj);
data = double(reshape(obj.Data, [nr nc]));

% run the kmeans algorithm
% (use statistics toolbox function)
[idx, centers] = kmeans(data, k);

% convert to label image, by avoiding zero label
idx = reshape(idx, size(obj));

% create parent image
newName = createNewName(obj, sprintf('%%s-kmeans%d', k));
res = Image('Data', idx, 'Parent', obj, ...
    'Type', 'label', 'Name', newName, ...
    'ChannelNames', {'Class'});
