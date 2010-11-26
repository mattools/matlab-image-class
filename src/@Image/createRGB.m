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


if nargin == 1
    % create RGB image from one Matlab array
    data = permute(varargin{1}, [2 1 4 3 5]);
    if size(data, 3)>1
        nd = 3;
    else
        nd = 2;
    end
    
    rgb = Image(nd, 'data', data);
    return;
end


% rename inputs
r = varargin{1};
g = varargin{2};
if nargin > 2
    b = varargin{3};
end

% choose one of the 3 inputs as reference
refImage = r;
if isempty(refImage)
    ref = g;
    if isempty(refImage)
        ref = b;
        if isempty(refImage)
            error('Can not manage three empty arrays');
        end
    end
end
% get ref size
dim = size(refImage);
nd = ndims(refImage);

% different processing for 2D or 3D images
if nd == 2
    % create empty result image
    if islogical(refImage)
        rgb = false([dim 3]);
    else
        rgb = zeros([dim 3], class(refImage));
    end
    
    % fill result with data
    if ~isempty(r), rgb(:,:,1) = r; end
    if ~isempty(g), rgb(:,:,2) = g; end
    if ~isempty(b), rgb(:,:,3) = b; end
elseif nd == 3
    % create empty result image
    newDim = [dim(1:2) 3 dim(3)];
    if islogical(ref)
        rgb = false(newDim);
    else
        rgb = zeros(newDim, class(refImage));
    end
    
    % fill result with data
    if ~isempty(r), rgb(:,:,1,:) = r; end 
    if ~isempty(g), rgb(:,:,2,:) = g; end
    if ~isempty(b), rgb(:,:,3,:) = b; end
else
    error('unprocessed image dimension');
end

rgb = permute(rgb, [2 1 4 3 5]);
rgb = Image(nd, 'data', rgb);
