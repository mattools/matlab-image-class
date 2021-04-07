function res = floodFill(obj, pos, value, varargin)
% Flood-fill operation from a position.
%
%   IMG2 = floodFill(IMG, POS, V)
%   Determines the region of connected pixels with the same value and
%   containing the position POS, and replaces their value by V.
%   
%   IMG2 = floodFill(IMG, POS, V, CONN)
%   Also specifies the connectivity to use. Default connectivity is 4 for
%   planar images, and 6 for 3D images.
%
%
%   Example
%     % remove the region corresponding to the label at a given position
%     img = Image.read('coins.png');
%     lbl = componentLabeling(img > 95, 4);
%     lbl2 = floodFill(lbl, [180 120], 0); % replaces by background
%     figure; show(lbl2); colormap jet;
%     
%   See also
%     reconstruction, fillHoles, killBorders
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-02-10,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE.

% check input dimensions
if size(pos, 2) ~= ndims(obj)
    error('Image:floodFill', ...
        'position array size must match image dimension');
end

% choose default connectivity depending on dimension
conn = defaultConnectivity(obj);

% case of connectivity specified by user
if ~isempty(varargin)
    conn = varargin{1};
end

% create binary image of mask
pos = num2cell(pos);
mask = obj == obj.Data(pos{:});

% binary image for marker
marker = Image.false(size(obj));
marker.Data(pos{:}) = true;

% compute the region composed of connected pixels with same value
rec = reconstruction(marker, mask, conn);

% replace values in result image
name = createNewName(obj, '%s-floodFill');
res = Image(obj, 'Name', name);
res.Data(rec.Data) = value;
