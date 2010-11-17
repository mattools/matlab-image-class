function varargout = splitChannels(this)
%SPLITCHANNELS Puts the different channels of a vector image in a cell array
%
%   CHANNELS = IMG.splitChannels();
%   CHANNELS is a cell array containing a planar imaeg for each channel of
%   the vector image.
%
%   Example
%   splitChannels
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
    res{i} = Image3D.create('data', this.data(:, :, :, i), 'parent', this);
end

% process output
if nargout<=1
    varargout{1} = res;
elseif nargout==nc
    varargout = res;
else
    error('Wrong number of outputs');
end
