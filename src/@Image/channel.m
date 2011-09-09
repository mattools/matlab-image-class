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
%   channelNumber, size
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nc = size(this, 4);
if index > nc
    pattern = 'Can not get channel number %d of a image with %d channels';
    error('Image:channel:IndexOutsideBounds', ...
        pattern, index, nc);
end

% create a new Image from data
nd = ndims(this);
channel = Image(nd, 'data', this.data(:,:,:,index,:), ...
    'parent', this, 'type', 'grayscale');
