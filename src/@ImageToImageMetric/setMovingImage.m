function setMovingImage(this, img)
%SETFIXEDIMAGE  Setup moving image of registration algorithm
%
%   REG.setMovingImage(IMG)
%   IMG can be either an instance of image, or an instance of
%   ImageFunction, for example an interpolated image.
%
%   Example
%   setMovingImage
%
%   See also
%   setFixedImage
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

this.img2 = img;