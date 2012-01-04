function res = morphoLaplacian(this, se)
%MORPHOLAPLACIAN Morphological laplacian of an intensity image
%
%   RES = morphoLaplacian(IMG, SE)
%   Computes the morphological gradient of the image IMG, using the
%   structuring element SE.
%
%   RES = morphoLaplacian(IMG)
%   Uses a n-dimensional ball (3-by-3 square in 2D, 3-by-3-by-3 cube in 3D)
%   as default structuring element.
%
%   Morphological laplacian is defined as half the sum of a morphological
%   dilation and a morphological erosion with the same structuring element,
%   minus the original image.
%       morphoLaplacian(I, SE) <=> (dilation(I, SE) + erosion(I, SE))/2 - I
%
%   This function is mainly a shortcut to apply all operations in one call.
%
%   Example
%     img = Image.read('cameraman.tif');
%     se = ones(3, 3);
%     mlap = morphoLaplacian(img, se);
%     show(mlap);
%
%   See also
%   dilation, erosion, morphoGradient
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-10-21,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% default structuring element
if nargin == 1
    se = defaultStructuringElement(this);
end

% compute laplacian of the data, using double for output
res = imadd(imdilate(this.data, se), imerode(this.data, se), 'double') / 2;
res = imsubtract(res, double(this.data));

% create the result image
res = Image('data', res, 'parent', this);
