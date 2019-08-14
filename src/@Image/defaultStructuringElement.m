function se = defaultStructuringElement(obj, varargin)
% Return a default structuring element for morphological operators.
%
%   SE = defaultStructuringElement(IMG)
%   Returns a default structuring element for obj image. The dimension of
%   structuring element depends on image dimension.
%
%   Example
%     defaultStructuringElement
%
%   See also
%     dilation, erosion, opening, closing

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nd = ndims(obj);
se = true(ones(1, nd));
