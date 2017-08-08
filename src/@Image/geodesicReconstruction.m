function res = geodesicReconstruction(marker, mask, varargin)
%GEODESICRECONSTRUCTION Geodesic reconstruction of marker image under mask image
%
%   Deprecated: use 'reconstruction' function instead.
%
%   REC = geodesicReconstruction(MARKER, MASK)
%   Performs a geodesic reconstruction of image defined by MARKER under the
%   mask given by MASK. Both MARKER and MASK should be images the same size
%   and the same type.
%   Geodesic reconstruction is used as base algorithm for several filters.
%
%   Example
%   geodesicReconstruction
%
%   See also
%   killBorders, fillHoles
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

warning('Image:deprecated', ...
    'method "geodesicReconstruction" is deprecated, use "reconstruction" instead');

[marker, mask, this] = parseInputCouple(marker, mask);
data = imreconstruct(marker, mask, varargin{:});

% create result image
res = Image('data', data, 'parent', this, 'type', this.type);
