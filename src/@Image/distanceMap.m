function map = distanceMap(obj, varargin)
% Distance map of a binary image (2D or 3D).
%
%   MAP = distanceMap(IMG)
%
%   Example
%   distanceMap
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check type
if ~strcmp(obj.Type, 'binary')
    error('Requires a binary image');
end

% compute distance map
dist = bwdist(obj.Data, varargin{:});

newName = '';
if ~isempty(obj.Name)
    newName = sprintf('distanceMap(%s)', obj.Name);
end

% create new image
map = Image('data', dist, ...
    'parent', obj, ...
    'name', newName, ...
    'type', 'intensity', ...
    'channelNames', {'distance'});
