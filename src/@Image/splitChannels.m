function varargout = splitChannels(obj)
% Split the different channels of the image.
%
%   CHANNELS = splitChannels(IMG)
%   [CHANNEL1, CHANNEL2 ... ] = splitChannels(IMG)
%   Splits the channels of the input image into several scalar images.
%   CHANNELS is a cell array of scalar images.
%   CHANNEL1, CHANNEL2... are individual scalar images.
%
%
%   Example
%     % Split a color image into 3 channels
%     img = Image.read('peppers.png');
%     [r g b] = splitChannels(img);
%     img2 = Image.createRGB(b, g, r);
%     show(img2);
%
%     % Split a color image into 3 channels
%     img = Image.read('peppers.png');
%     bands = splitChannels(img);
%     for i = 1:length(bands)
%       subplot(1, length(bands), i);
%       show(bands{i});
%     end
%
%   See also
%     catChannels, createRGB, isVectorImage, channelCount
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-12-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nc = size(obj, 4);
res = cell(1, nc);

for i = 1:nc
    res{i} = channel(obj, i);
end

if nargout <= 1
    varargout = {res};
else
    varargout = res;
end
