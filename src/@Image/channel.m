function channel = channel(this, index)
%CHANNEL Return a specific channel of a Vector Image
%
%   CHANNEL = channel(IMG, INDEX)
%   Returns the channel indexed by INDEX in a vector or color image.
%   INDEX is 1-indexed. CHANNEL is a scalar image with the same spatial
%   dimension as the input image.
%
%   Example
%   img = Image.read('peppers.png');
%   red = channel(img, 1);
%   green = channel(img, 2);
%   
%
%   See also
%   channelNumber
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% create a new Image from data
nd = ndims(this);
channel = Image(nd, 'data', this.data(:,:,:,index,:), ...
    'parent', this, 'type', 'grayscale');
