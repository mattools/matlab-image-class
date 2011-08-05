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

% default values
conn = 4;
if this.dimension == 3
    conn = 6;
end

% process input arguments
while ~isempty(varargin)
    var = varargin{1};

    if isnumeric(var) && isscalar(var)
        % extract connectivity
        conn = var;
        varargin(1) = [];
        continue;
    end
end

data = imextendedmin(this.data, dyn, conn);

% create result image
res = Image(this.dimension, 'data', data, 'parent', this, 'type', this.type);
