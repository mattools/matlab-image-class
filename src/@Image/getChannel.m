function channel = getChannel(this, index)
%GETCHANNEL Return a specific channel of a Vector Image
%
%   CHANNEL = img.getChannel(INDEX)
%   INDEX is 1-indexed.
%   CHANNEL is a scalar image the same dimension as the input image
%
%   Deprecated, use 'channel' instead.
%
%   Example
%   channel
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

warning('Image:deprecated', ...
    '''getChannel'' is deprecated, use ''channel'' instead');

% create a new Image from data
channel = Image('data', this.data(:,:,:,index,:), ...
    'parent', this, 'type', 'grayscale');
