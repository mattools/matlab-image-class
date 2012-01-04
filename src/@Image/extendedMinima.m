function res = extendedMinima(this, dyn ,varargin)
%EXTENDEDMINIMA  Extended minima of the image
%
%   IMGMIN = extendedMinima(IMG, DYN)
%
%   Example
%   extendedMinima
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-01,    using Matlab 7.9.0.529 (R2009b)
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

data = imextendedmin(this.data, dyn, conn);

% create result image
res = Image('data', data, 'parent', this, 'type', this.type);
