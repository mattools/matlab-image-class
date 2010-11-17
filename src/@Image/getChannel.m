function channel = getChannel(this, index)
%GETCHANNEL Returns a specific channel of a Vector Image
%
%   CHANNEL = img.getChannel(INDEX)
%   INDEX is 1-indexed.
%   CHANNEL is a scalar image the same dimension asthe input image
%
%   Example
%   getChannel
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% create a new Image2D from data
channel = Image('data', this.data(:,:,:,index,:), 'parent', this);
