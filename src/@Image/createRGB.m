function rgb = createRGB(varargin)
%CREATERGB  Create a RGB color image
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
%   createRGB
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% note: function is adapted from an earlier script, so it could be greatly
% improved when initialising data array

if nargin == 1
    % create RGB image from one Matlab array
    data = permute(varargin{1}, [2 1 4 3 5]);
    if size(data, 3)>1
        nd = 3;
    else
        nd = 2;
    end
    
    rgb = Image(nd, 'data', data, 'type', 'color');
    return;
end


% rename inputs
r = varargin{1};
g = varargin{2};
b = [];
if nargin > 2
    b = varargin{3};
end

% choose one of the 3 inputs as reference
refImage = r;
if isempty(refImage)
    refImage = g;
    if isempty(refImage)
        refImage = b;
        if isempty(refImage)
            error('Can not manage three empty arrays');
        end
    end
end

% get reference size, and number of spatial dimensions
if isa(refImage, 'Image')
    % get size in ijk ordering
    dim = getSize(refImage);
    dim = dim([2 1 3:end]);
else
    dim = size(refImage);
end
nd = length(dim);

% eventually convert images to buffers
if isa(r, 'Image')
    r = getBuffer(r);
end
if isa(g, 'Image')
    g = getBuffer(g);
end
if isa(b, 'Image')
    b = getBuffer(b);
end

% Dimension of result image
if nd == 2
    dim = [dim 1];
end
newDim = [dim(1:2) 3 dim(3)];

% compute data type of image
newType = class(refImage);
if isa(refImage, 'Image')
    newType = getDataType(refImage);
end

% create empty result image
if strcmp(newType, 'logical')
    rgb = false(newDim);
else
    rgb = zeros(newDim, newType);
end


% different processing for 2D or 3D images
if nd == 2
    % fill result with data
    if ~isempty(r), rgb(:,:,1) = r; end
    if ~isempty(g), rgb(:,:,2) = g; end
    if ~isempty(b), rgb(:,:,3) = b; end
    
elseif nd == 3    
    % fill result with data
    if ~isempty(r), rgb(:,:,1,:) = r; end 
    if ~isempty(g), rgb(:,:,2,:) = g; end
    if ~isempty(b), rgb(:,:,3,:) = b; end
    
else
    error('unprocessed image dimension');
end

% convert from matlab indexing to xyzct indexing
rgb = permute(rgb, [2 1 4 3 5]);

% create new image object
rgb = Image(nd, 'data', rgb, 'type', 'color');
