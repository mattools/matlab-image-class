function nc = channelCount(this)
% Returns the number of channels of the image.
%
%   NC = channelCount(IMG)
%   Returns the number of channels (color components, or spectral bands...)
%   of the input image. For grayscale or binary images, returns 1.
%
%   Example
%   img = Image.read('peppers.png');
%   channelCount(img)
%   ans = 
%        3
%
%   See also
%     size, channel, splitChannels, frameCount
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-11-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nc = size(this.Data, 4);