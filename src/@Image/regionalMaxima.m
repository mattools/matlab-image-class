function res = regionalMaxima(obj, varargin)
% Regional maxima of the image.
%
%   IMGMAX = regionalMaxima(IMG)
%
%   Example
%   regionalMaxima
%
%   See also
%   regionalMinima, extendedMaxima, reconstruction
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-01,    using Matlab 7.9.0.529 (R2009b)
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


data = imregionalmax(obj.Data, conn);

% create result image
name = createNewName(obj, '%s-maxima');
res = Image('Data', data, 'Parent', obj, 'Type', 'binary', 'Name', name);
