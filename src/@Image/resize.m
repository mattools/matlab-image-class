function res = resize(obj, k, varargin)
% Resize an image (2D or 3D).
%
%   IMG2 = resize(IMG, K)
%   Resizes the input image IMG by the factor K, such that the size of the
%   new image is K times the size of IMG.
%
%
%   Example
%     % resize a grayscale image
%     img = Image.read('coins.png');
%     size(img)
%     ans = 
%        300  246
%     img2 = resize(img, .25);
%     size(img2)
%     ans =
%         75   62
%     % Both images should have similar extents.
%     [physicalExtent(img) ; physicalExtent(img2)]
%     ans =
%         0.5000  300.5000    0.5000  246.5000
%         0.5000  300.5000    0.5000  248.5000
%
%     % resize a color image
%     img = Image.read('peppers.png');
%     size(img)
%     ans =
%        512   384
%     img2 = resize(img, .2);
%     size(img2)
%     ans =
%        103    77
%
%     % Resize color image, and overlay a cropped portion at initial resolution
%     img = Image.read('peppers.png');
%     img2 = resize(img, 1/8);
%     figure; show(img2, 'InitialMagnification', 8*100);
%     box = [71 240 181 330];
%     imgC = crop(img, box);
%     hold on; show(imgC);
%
%     % resize a 3D image, using different resize ratios
%     img = Image.read('brainMRI.hdr');
%     size(img)
%     ans =
%        128   128    27
%     img2 = resize(img, [.5 .5 1]);
%     size(img2)
%     ans =
%         64    64    27
%
%   See also
%     size, crop, resample
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-08-08,    using Matlab 9.1.0.441655 (R2016b)
% Copyright 2017 INRA - Cepia Software Platform.

% eventually convert vector of scale factors into new dims
if length(k) > 1 && any(k < 1.0)
    k = obj.DataSize(1:obj.Dimension) .* k;
end

% process data buffer, using Matlab's Image Processing Toolbox
if obj.Dimension <= 2
    data = imresize(obj.Data, k, varargin{:});
else
    data = imresize3(obj.Data, k, varargin{:});
end

% compute new spatial calibration
sp2 = obj.Spacing ./ k;
or2 = (obj.Origin - obj.Spacing * 0.5) + sp2 * 0.5;

% create new image object for storing result
name = createNewName(obj, '%s-resize');
res = Image('Data', data, 'Parent', obj, 'Name', name, ...
    'Spacing', sp2, 'Origin', or2);
