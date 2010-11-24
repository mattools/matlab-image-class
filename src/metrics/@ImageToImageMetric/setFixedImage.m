function setFixedImage(this, img)
%SETFIXEDIMAGE  Setup fixed image of registration algorithm
%
%   REG.setFixedImage(IMG)
%   IMG can be either an instance of image, or an instance of
%   ImageFunction, for example an interpolated image.
%
%   Example
%   setFixedImage
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

this.img1 = img;