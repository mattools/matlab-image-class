function varargout = splitChannels(this)
%SPLITCHANNELS Split the different channels of a vector image
%
%   CHANNELS = IMG.splitChannels();
%   CHANNELS is a cell array containing a planar image for each channel of
%   the vector image.
%
%   [C1 C2] = IMG.splitChannels();
%   [C1 C2 C3] = IMG.splitChannels();
%   Returns each channel image in a specific variable. The number of output
%   arguments must be the same as the number of channels.
%
%   Example
%     % Display gradient components of a planar image
%     img = Image.read('cameraman.tif');l
%     grad = img.gradient;
%     grad.show;
%     channels = grad.splitChannels();
%     figure;
%     for i=1:2
%         subplot(1, 2, i);
%         channels{i}.show();
%     end
%
%     % Extract gradients in specific variables
%     img = Image.read('cameraman.tif');
%     grad = img.gradient;
%     grad.show;
%     [gx gy] = grad.splitChannels();
%     figure;
%     subplot(1, 2, 1); gx.show();
%     subplot(1, 2, 2); gy.show();
% 
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

nc = this.getChannelNumber();

res = cell(1, nc);
for i=1:nc
    res{i} = Image2D.create('data', this.data(:, :, i), 'parent', this);
end

% process output
if nargout<=1
    varargout{1} = res;
elseif nargout==nc
    varargout = res;
else
    error('Wrong number of outputs');
end
