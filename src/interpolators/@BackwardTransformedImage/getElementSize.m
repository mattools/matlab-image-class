function d = getElementSize(this)
%GETELEMENTSIZE Dimension of an image element
%
%   D = TIM.getElementSize();
%   Returns the size of an image element. Returns [1 1] in the case of a
%   scalar image, [NC 1] in the case of a vector image.
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-10-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

d = this.interpolator.getElementSize();
