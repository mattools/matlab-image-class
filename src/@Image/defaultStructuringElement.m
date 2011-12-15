function se = defaultStructuringElement(this, varargin)
%DEFAULTSTRUCTURINGELEMENT  Returns a default structuring element
%
%   SE = defaultStructuringElement(IMG)
%   Returns a default structuring element for this image. The dimension of
%   structuring element depends on image dimension.
%
%   Example
%   defaultStructuringElement
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nd = ndims(this);
se = true(ones(1, nd));
