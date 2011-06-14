function res = morphoGradient(this, se)
%MORPHOGRADIENT Morphological gradient of an intensity image
%
%   RES = morphoGradient(IMG, SE)
%   Computes the morphological gradient of the image IMG, using the
%   structuring element SE.
%
%   Morphological gradient is defined as the difference of a morphological
%   dilation and a morphological erosion with the same structuring element.
%   This function is mainly a shortcut to apply all operations in one call.
%
%   Example
%   img = Image.read('cameraman.tif');
%   se = ones(3, 3);
%   mgrad = morphoGradient(img, se);
%   show(mgrad);
%
%   See also
%   dilate, erode, subtract
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

if nargin == 1
    se = ones(3 * ones(1, this.dimension));
end

res = imsubtract(imdilate(this.data, se), imerode(this.data, se));

res = Image.create('data', res, 'parent', this);
