function res = geodesicReconstruction(marker, mask, varargin)
%GEODESICRECONSTRUCTION Geodesic reconstruction of marker image under mask image
%
%   REC = geodesicReconstruction(MARKER, MASK)
%
%   Example
%   geodesicReconstruction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

data = imreconstruct(marker, mask, varargin{:});

% create result image
res = Image(this.dimension, 'data', data, 'parent', this, 'type', this.type);
