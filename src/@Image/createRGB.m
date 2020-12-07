function rgb = createRGB(red, green, blue)
% Create a RGB color image from scalar channels.
%
%   RGB = createRGB(DATA)
%   Create a RGB image from data array DATA, using the third dimension as
%   channel dimension.
%   Input array DATA can be either a 3D or a 4D array, resulting in a 2D or
%   3D image. DATA is ordered using Matlab convention: y, x, channel, z.
%
%   RGB = createRGB(RED, GREEN, BLUE)
%   Concatenates the 3 data arrays to form a RGB color image. Inputs can be
%   either 2D or 3D, but they must have the same dimension. One of them can
%   be empty.
%   
%
%   Example
%     createRGB
%
%   See also
%     create, Image, catChannels

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-11-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% note: function is adapted from an earlier script, so it could be greatly
% improved when initialising data array


%% Special case of function called with a single argument

if nargin == 1
    % only a single data array is provided. extract red, green and blue
    % from first input.
    if isa(red, 'Image')
        % input is an image with at least 3 channels
        rgb = channel(red, [1 2 3]);
        rgb.Type = 'color';
        
    else
        if ndims(red) == 3
            % input is a planar color array
            green   = permute(red(:, :, 2), [2 1 4 3]);
            blue    = permute(red(:, :, 3), [2 1 4 3]);
            red     = permute(red(:, :, 1), [2 1 4 3]);
        else
            % input is a 3D color array
            green   = permute(red(:, :, 2), [2 1 4 3]);
            blue    = permute(red(:, :, 3), [2 1 4 3]);
            red     = permute(red(:, :, 1), [2 1 4 3]);
        end
        
        % create new color image
        rgb = Image('data', cat(4, red, green, blue), 'type', 'color');
    end
    return;
end


%% Generic case: the three channels are given as argument

% create empty variable names if necessary
if nargin < 3
    blue = [];
end

% choose one of the 3 inputs as reference
if ~isempty(red)
    refImage = red;
elseif ~isempty(green)
    refImage = green;
elseif ~isempty(blue)
    refImage = blue;
else
    error('Can not manage three empty arrays');
end

% get reference size, and number of spatial dimensions
if isa(refImage, 'Image')
    % get size in xyz ordering
    dim = size(refImage);
else
    % get size in ijk order, and convert to xyz
    dim = size(refImage);
    dim = dim([2 1 3:end]);
end
nd = length(dim);

% Extract final data buffer of each channel, either by extracting image
% data, or by permuting dimension of matlab arrays
if isa(red, 'Image')
    red = getDataBuffer(red);
else
    red = permute(red, [2 1 3:nd]);
end
if isa(green, 'Image')
    green = getDataBuffer(green);
else
    green = permute(green, [2 1 3:nd]);
end
if isa(blue, 'Image')
    blue = getDataBuffer(blue);
else
    blue = permute(blue, [2 1 3:nd]);
end

% Dimension of result image
if nd == 2
    dim = [dim 1];
end
newDim = [dim(1:3) 3 frameCount(refImage)];

% compute data type of image
if isa(refImage, 'Image')
    newType = getDataType(refImage);
else
    newType = class(refImage);
end

if strcmp(newType, 'logical')
    newType = 'uint8';
end

% create empty result image
rgb = zeros(newDim, newType);

% fill result with data
if ~isempty(red),   rgb(:,:,:,1,:) = red;   end
if ~isempty(green), rgb(:,:,:,2,:) = green; end
if ~isempty(blue),  rgb(:,:,:,3,:) = blue;  end

% create new image object
rgb = Image('data', rgb, 'type', 'color');

% also propagates spatial calibration
if isa(refImage, 'Image')
    copySpatialCalibration(rgb, refImage);
end
