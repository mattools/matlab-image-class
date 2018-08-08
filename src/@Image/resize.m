function res = resize(this, k)
%RESIZE Resize an image
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
%   See also
%     size, crop, resample
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-08-08,    using Matlab 9.1.0.441655 (R2016b)
% Copyright 2017 INRA - Cepia Software Platform.

% process data buffer, using Matlab Image processing Toolbox
data = imresize(this.data, k);

% create new image object for storing result
res = Image('data', data, 'parent', this);
