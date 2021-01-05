function res = imposeMaxima(obj, marker, varargin)
% Impose maxima on a grayscale or intensity image.
%
%   output = imposeMaxima(input)
%
%   Example
%   imposeMaxima
%
%   See also
%     imposeMinima, imimposemin
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-07-31,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check image type
if ~strcmp(obj.Type, 'grayscale') && ~strcmp(obj.Type, 'intensity')
    error('Requires a Grayscale or intensity image to work');
end

% default values
conn = 4;

if obj.Dimension == 3
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
    marker = marker.Data;
end

% use imposemin on complement image, and complement the result
data = imcomplement(imimposemin(imcomplement(obj.Data), marker, conn));

% create result image
name = createNewName(obj, '%s-impMax');
res = Image('Data', data, 'Parent', obj, 'type', obj.Type, 'Name', name);
