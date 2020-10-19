function [data, colNames, coords] = unfold(obj)
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
%
%   See also
%     Table, fold, kmeans
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-11-19,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRAE - Cepia Software Platform.

% check type
if ~isVectorImage(obj)
    return;
end

% size of the table
nr = elementNumber(obj);
nc = channelNumber(obj);

% create column names array
colNames = obj.ChannelNames;
if isempty(obj.ChannelNames) || length(obj.ChannelNames) ~= nc
    warning('ChannelNames property was not correctly initialized');
    colNames = cell(1, nc);
    for i = 1:nc
        colNames{i} = sprintf('Ch%02d', i);
    end
end

% create data table
data = reshape(obj.Data, [nr nc]);

% optionnaly creates table of coordinates
if nargout > 2
    % create sampling grid (iterating over x first)
    lx = 1:size(obj, 1);
    ly = 1:size(obj, 2);
    if size(obj, 3) > 1
        lz = 1:size(obj, 3);
        [y, x, z] = meshgrid(ly, lx, lz);
        coords = [x(:) y(:) z(:)];
    else
        [y, x] = meshgrid(ly, lx);
        coords = [x(:) y(:)];
    end
end
 