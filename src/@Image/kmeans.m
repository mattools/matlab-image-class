function [res, centers] = kmeans(obj, k, varargin)
% Apply k-means clustering to a multi-channel image.
%
%   CLASSES = kmeans(IMG, K)
%   Compute kmeans clustering of the multi-channel image IMG, using K
%   classes.
%
%   [CLASSES, CENTERS] = kmeans(IMG, K);
%   Also returns the coordinates of class centers. CENTERS is a K-by-NC
%   array, where NC is the number of channels of original image IMG.
%
%
%   Example
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
%   See also
%     label2rgb
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-01-15,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE.

if channelNumber(obj) < 2
    error('Requires a multi-channel image');
end

% convert image content into nr-by-nc array
nr = elementNumber(obj);
nc = channelNumber(obj);
data = double(reshape(obj.Data, [nr nc]));

% run the kmeans algorithm
[idx, centers] = kmeans(data, k);

% convert to label image, by avoiding zero label
idx = reshape(idx, size(obj));

% create parent image
newName = 'classes';
if ~isempty(obj.Name)
    newName = sprintf('%s-kmeans%d', obj.Name, k);
end
res = Image('Data', idx, 'Type', 'label', ...
    'parent', obj, 'Name', newName, ...
    'ChannelNames', {'Class'});