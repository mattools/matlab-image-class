function res = gaussianFilter(this, kernelSize, sigma, varargin)
%GAUSSIANFILTER Gaussian filter of image using separability
%
%   IMGF = gaussianFilter(IMG, SIZE, SIGMA)
%   IMG is the input image,
%   SIZE is the size of the convolution kernel, either as a scalar, or as a
%   1-by-ND row vector containging size in the X, Y, and eventually z
%   direction.
%   SIGMA is the width of the kernel, either as a scalar (the same sigma
%   will be used in each direction), or as a row vector containing sigmax,
%   sigmay, and eventually sigmaz.
%
%   The function works for 2D or 3D images, for grayscale or color images.
%   In case of color images, the filtering is repeated for each channel of
%   the image.
%
%   IMGF = gaussianFilter(IMG, SIZE, SIGMA, OPTIONS)
%   Apply the same kind of options than for imfilter.
%
%   RES = gaussianFilter(IMG, SE, PADOPT) 
%   also specify padding option. PADOPT can be one of:
%     X (numeric value)
%     'symmetric'
%     'replicate'
%     'circular'
%   see imfilter for details. Default is 'replicate'. 
%
%   Example
%     img = Image.read('cameraman.tif');
%     imgf = gaussFilter(img, 11, 4);
%     % is equivalent, but is in general faster, that:
%     imgf2 = filter(img, fspecial('gaussian', 11, 4));
%
%     Note that there can be slight differences due to rounding effects. To
%     minimize them, it is possible to use something like:
%     imgf3 = uint8(imGaussFilter(single(img), 11, 4));
%
%
%   See also:
%   meanFilter, filter, imfilter
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-05-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Process special cases

% case of color images
if isColorImage(this)
    r = gaussianFilter(channel(this, 1), kernelSize, sigma, varargin{:});
    g = gaussianFilter(channel(this, 1), kernelSize, sigma, varargin{:});
    b = gaussianFilter(channel(this, 1), kernelSize, sigma, varargin{:});
    res = Image.createRGB(r, g, b);
    return;    
end


%% Process input arguments

nd = this.dimension;

% process kernel size
if nargin < 2
    kernelSize = 3;
end
if length(kernelSize) == 1
    kernelSize = repmat(kernelSize, 1, nd);
end

% process filter sigma
if nargin < 3
    sigma = 3;
end
if length(sigma) == 1
    sigma = repmat(sigma, 1, nd);
end

% get Padopt option
padopt = 'replicate';
if ~isempty(varargin)
    padopt = varargin{1};
end


%% Main processing

% init result
data = this.data;

% process each direction
for i = 1:nd
    % compute spatial reference
    refSize = (kernelSize(i) - 1) / 2;
    s0 = floor(refSize);
    s1 = ceil(refSize);
    lx = -s0:s1;
    
    % compute normalized kernel
    sigma2 = 2*sigma(i).^2;
    kernel = exp(-(lx.^2 / sigma2));
    kernel = kernel / sum(kernel);
    
    % reshape the kernel such as it is elongated in the i-th direction
    newDim = [ones(1, i-1) kernelSize(i) ones(1, nd-i)];
    kernel = reshape(kernel, newDim);
    
    % apply filtering along one direction
    data = imfilter(data, kernel, padopt);
end

% create result image
res = Image('data', data, 'parent', this);
