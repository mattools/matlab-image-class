function channel = channel(this, index)
%CHANNEL Return a specific channel of a Vector Image
%
%   CHANNEL = channel(IMG, INDEX)
%   Returns the channel indexed by INDEX in a vector or color image.
%   INDEX is 1-indexed. CHANNEL is a scalar image with the same spatial
%   dimension as the input image.
%
%   Example
%     % read a color image, extyract channels, and creates a new image with
%     % channels in difference order
%     img = Image.read('peppers.png');
%     red = channel(img, 1);
%     green = channel(img, 2);
%     blue = channel(img, 3);
%     show(Image.createRGB(green, blue, red));
%
%   See also
%     channelNumber, catChannels, splitChannels
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% check index bounds
nc = size(this, 4);
if index > nc
    pattern = 'Can not get channel %d of an image with %d channels';
    error('Image:channel:IndexOutsideBounds', ...
        pattern, index, nc);
end

% compute the name of the new image
if ~isempty(this.channelNames)
    channelName = this.channelNames{index};
else
    channelName = sprintf('channel%d', index);
end
name = sprintf('%s-%s', this.name, channelName);

% create a new Image from data
channel = Image('data', this.data(:,:,:,index,:), ...
    'parent', this, 'type', 'grayscale', 'name', name);
