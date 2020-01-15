function [data, coords] = unfold(obj)
% Unfold a vector image.
%
%   TAB = unfold(VIMG);
%   Unfold the vector image VIMG, and returns an array with as many
%   rows as the number of pixels in VIMG, and as many columns as the number
%   of channels.
%
%   Example
%     img = Image.read('peppers.png');
%     prod(size(img))
%     ans =
%           196608
%     tab = unfold(img);
%     size(tab)
%     ans =
%           196608           3
%     head(tab)
%     ans = 
%              Ch01    Ch02    Ch03
%     1          62      29      64
%     2          63      31      64
%     3          63      34      64
%     4          65      30      60
%     5          66      27      59
%     6          63      31      62
%
%   See also
%     Table
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-19,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - Cepia Software Platform.

if ~isVectorImage(obj)
    return;
end

% size of the table
nr = elementNumber(obj);
nc = channelNumber(obj);

% create column names array
colNames = cell(1, nc);
for i = 1:nc
    colNames{i} = sprintf('Ch%02d', i);
end

% create data table
data = reshape(obj.Data, [nr nc]);
% tab = Table(data, colNames);

% optionnaly creates table of coordinates
if nargout > 1
    % create sampling grid (iterating over x first)
    lx = 1:size(obj, 1);
    ly = 1:size(obj, 2);
    [y, x] = meshgrid(ly, lx);
    coords = [reshape(x, [numel(x) 1]), reshape(y, [numel(x) 1])];
%     coordsTab = Table(coords, {'x', 'y'}, tab.RowNames);
end
 