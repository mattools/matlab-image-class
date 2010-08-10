function res = plus(this, arg)
%Add two images or add scalar to image
%   
%   res = img1 + c;
%   res = plus(img1, c);
%   res = img1.plus(c);
%   add a constant to each pixel of the image.
%
%   res = img1 + img2;
%   res = plus(img1, img2);
%   res = img1.plus(img2);
%   add the coresponding values of pixels in img1 and img2.
%
%   Example
%   img = Image2D('cameraman.tif');
%   show(img + 100);
%
%   See also
%   imadd, Image2D/minus
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-02-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isa(arg, 'Image2D')
    dim1 = this.getSize();
    dim2 = arg.getSize();
    if sum(dim1~=dim2)>0
        error('Images should have the same size');
    end
    
    res = Image2D(this);
    res.data = imadd(this.data, arg.data);
elseif isnumeric(arg)
    % add a scalar
    res = Image2D(this);
    res.data = imadd(this.data, arg);
else
    error('Unknown argument type in Image2D/plus');
end
