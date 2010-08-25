function setTransformModel(this, transfo)
%SETTRANSFORMMODEL  Setup parametric transform associated with registration
%
%   REG.setTransformModel(TRANSFO)
%   TRANSFO is an instance of ParametricTransform.
%
%   Example
%   setTransformModel
%
%   See also
%   setFixedImage
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

this.transfo = transfo;
if ~isempty(this.img2)
    this.tmi = BackwardTransformedImage(this.img2, this.transfo);
end
