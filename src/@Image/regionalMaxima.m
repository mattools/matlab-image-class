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

data = imregionalmax(obj.Data, conn);

% create result image
name = createNewName(obj, '%s-maxima');
res = Image('Data', data, 'Parent', obj, 'Type', 'binary', 'Name', name);
