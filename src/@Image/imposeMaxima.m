function res = imposeMaxima(this, marker, varargin)
%IMPOSEMAXIMA Impose maxima on a grayscale or intensity image
%
%   output = imposeMaxima(input)
%
%   Example
%   imposeMaxima
%
%   See also
%     imposeMinima

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-07-31,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check image type
if ~strcmp(this.type, 'grayscale') && ~strcmp(this.type, 'intensity')
    error('Requires a Grayscale or intensity image to work');
end

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

if isa(marker, 'Image')
    marker = marker.data;
end

% use imposemin on complement image, and complement the result
data = imcomplement(imimposemin(imcomplement(this.data), marker, conn));

% create result image
res = Image('data', data, 'parent', this, 'type', this.type);
