function img = fold(array, dims, varargin)
% Create a new vector image by folding row elements in an array.
%
%   IMG = fold(ARRAY, DIMS)
%   Transforms the N-by-P numeric array into a vector image with P channels
%   and spatial dimensions given by DIMS. The products of DIMS must equal
%   the number of rows in the array (N).
%
%   Example
%     % Read color image, and convert to N-by-P Table class
%     img = Image.read('peppers.png');
%     tab = unfold(img);
%     % Performs basic clustering
%     km = kmeans(tab, 6);
%     % Convert result to image using the 'fold' method
%     img2 = Image.fold(km+1, size(img), 'Type', 'label', 'Name', 'km6 labels');
%     figure; show(label2rgb(img2, 'jet'));
%
%   See also
%     unfold
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-10-19,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.

% process data provided as Table
tab = [];
if isa(array, 'Table')
    tab = array;
    array = tab.Data;
end

% retrieve array size
nr = size(array, 1);
nc = size(array, 2);

if prod(dims) ~= nr
    error('The number of elements of output image must match the row number of array');
end

% allocate memory for image data
data = zeros([dims nc], 'like', array);

% copy each column into an image channel
nd = length(dims);
subs = [repmat({':'}, 1, nd) {1}];
for i = 1:nc
    subs{end} = i;
    data(subs{:}) = reshape(array(:,i), dims);
end

% Defulat meta-data for new image
newName = 'fold';
if nc == 1
    channelNames = {'Intensity'};
else
    channelNames = cell(1,nc);
    for i = 1:nc
        channelNames{i} = sprintf('Ch%02d', i);
    end
end

% choose result image name
if ~isempty(tab)
    if ~isempty(tab.Name)
        newName = [tab.Name '-fold'];
    end
    channelNames = tab.ColNames;
end

% create result Image
img = Image('Data', data, 'Vector', nc > 1, ...
    'Name', newName, ...
    'ChannelNames', channelNames, ...
    varargin{:});
