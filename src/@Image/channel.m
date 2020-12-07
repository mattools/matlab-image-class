function channel = channel(obj, index, varargin)
% Return a specific channel from a multi-channel Image.
%
%   CHANNEL = channel(IMG, INDEX)
%   Returns the channel indexed by INDEX in a vector or color image.
%   INDEX is 1-indexed. CHANNEL is a scalar image with the same spatial
%   dimension as the input image.
%
%   CHANNEL = channel(IMG, INDS)
%   Where INDS is a row vector of indices between 1 and the number of
%   channels in image. Returns a new vector image with the specified
%   channels.
%
%
%   Example
%   % read a color image, extract channels, and creates a new image with
%   % channels in difference order
%     img = Image.read('peppers.png');
%     red = channel(img, 1);
%     green = channel(img, 2);
%     blue = channel(img, 3);
%     show(Image.createRGB(green, blue, red));
%
%   See also
%     channelCount, catChannels, splitChannels
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% check index bounds
nc = size(obj, 4);
if any(index > nc)
    pattern = 'Can not get channel %d of an image with %d channels';
    error('Image:channel:IndexOutsideBounds', ...
        pattern, index, nc);
end

% determines the new type (vector if several channels are given)
if length(index) == 1
    if isfloat(obj.Data)
        newType = 'intensity';
    else
        newType = 'grayscale';
    end
    
elseif length(index) == 3
    newType = 'color';
else
    newType = 'vector';
end

% compute the channel names of the new image
if ~isempty(obj.ChannelNames)
    channelNames = obj.ChannelNames(index);
else
    % if channel names were not initialized, use channel numbers
    channelNames = cell(1, length(index));
    for i = 1:length(index)
        channelNames{i} = sprintf('Channel%d', index(i));
    end
end

% compute name of new image
if length(channelNames) == 1
    newName = sprintf('%s-%s', obj.Name, channelNames{1});
else
    newName = sprintf('%s-channels', obj.Name);
end
    
% create a new Image
channel = Image('data', obj.Data(:,:,:,index,:), ...
    'parent', obj, 'type', newType, 'name', newName, ...
    'channelNames', channelNames, varargin{:});
