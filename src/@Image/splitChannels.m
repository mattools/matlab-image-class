function varargout = splitChannels(this)
%SPLITCHANNELS Split the different channels of the image
%
%   [CHANNEL1 CHANNEL2 ... ] = splitChannels(IMG)
%
%   Example
%     img = Image.read('peppers.png');
%     [r g b] = splitChannels(img);
%     img2 = Image.createRGB(b, g, r);
%     show(img2);
%
%   See also
%     catChannels, createRGB
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nc = size(this, 4);
varargout = cell(1, nc);

for i = 1:nc
    varargout{i} = channel(this, i);
end
