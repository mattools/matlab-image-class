function map = distanceMap(obj, varargin)
% Distance map of a binary image (2D or 3D).
%
%   MAP = distanceMap(BIN)
%   The distance transform is an operator applied to binary images, that
%   results in an intensity image that contains, for each foreground pixel,
%   the distance to the closest background pixel.  
%
%   This function requires binary image as input. For label images that
%   contain adjacent regions, the function 'chamferDistanceMap' could be
%   more adapted.
%
%   Example
%     img = Image.read('circles.png');
%     map = distanceMap(img);
%     show(map)
%
%   See also
%     skeleton, geodesicDistanceMap, chamferDistanceMap

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2011-03-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2021 INRAE.

% check type
if ~strcmp(obj.Type, 'binary')
    error('Requires a binary image');
end

% compute distance map
dist = bwdist(~obj.Data, varargin{:});

newName = createNewName(obj, '%s-distMap');

% create new image
map = Image('Data', dist, ...
    'Parent', obj, ...
    'Name', newName, ...
    'Type', 'intensity', ...
    'ChannelNames', {'distance'});
