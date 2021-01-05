function res = killBorders(obj, varargin)
% Remove borders of a binary or grayscale image.
%
%   RES = killBorders(IMG)
%   RES = killBorders(IMG, CONN)
%   
%
%   Example
%     % Select rice grains within image
%     img = Image.read('rice.png');
%     bin = whiteTopHat(img, ones(50, 50)) > 50;
%     bin2 = killBorders(bin);
%     show(overlay(img, bin2))
%
%   See also
%     reconstruction, attributeOpening, areaOpening, fillHoles
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-09-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% choose default connectivity
conn = 4;
if ndims(obj) == 3
    conn = 8;
end

% case of connectivity specified by user
if ~isempty(varargin)
    conn = varargin{1};
end

% call matlab function
newData = imclearborder(obj.Data, conn);

% create resulting image
name = createNewName(obj, '%s-killBorders');
res = Image('Data', newData, 'Parent', obj, 'Name', name);
