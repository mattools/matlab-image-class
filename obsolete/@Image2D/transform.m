function [res isInside] = transform(this, transfo, varargin)
%TRANSFORM  Apply an affine transform to an image
%
%   RES = IMG.transform(TRANSFO)
%   RES = transform(IMG, TRANSFO)
%   TRANSFO must an invertibel transform, such as an affine transform.
%
%   Example
%   transform
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-02-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

[res isInside] = backwardTransform(this, ...
    transfo.getInverse(), varargin{:});
