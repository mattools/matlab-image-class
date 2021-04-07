function res = imposeMinima(obj, marker, varargin)
% Impose minima on a grayscale or intensity image.
%
%   RES = imposeMinima(IMG, MARKERS)
%   RES = imposeMinima(IMG, MARKERS, CONN)
%
%   Example
%   imposeMinima
%
%   See also
%     regionalMinima, extendedMinima
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

% choose default connectivity depending on dimension
conn = defaultConnectivity(obj);

% case of connectivity specified by user
if ~isempty(varargin)
    conn = varargin{1};
end


if isa(marker, 'Image')
    marker = marker.Data;
end

data = imimposemin(obj.Data, marker, conn);

% create result image
name = createNewName(obj, '%s-impMin');
res = Image('Data', data, 'Parent', obj, 'Type', obj.Type, 'Name', name);
