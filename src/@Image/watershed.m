function res = watershed(this, varargin)
%WATERSHED Watershed of a gray-scale image
%
%   WAT = watershed(IMG)
%   Computes the watershed of the intenity or grayscale image IMG.
%
%   WAT = watershed(IMG, CONN)
%   WAT = watershed(..., 'conn', CONN)
%   Specifies the connectivity to use. Default is 4 for 2D images and 6 for
%   3D images.
%
%   WAT = watershed(..., 'marker', MARKER)
%   Use a marker image to initialize watershed. MARKER should be a binary
%   image with the same size as IMG.
%
%   WAT = watershed(..., 'dynamic', DYN)
%   Computes marker by detecting minima based on dynamic in image. 
%
%   Example
%     % Segment rice grains from gradient image
%     img = Image.read('rice.png');
%     gradn = norm(gradient(img));
%     gf = filter(gradn, ones(3, 3)/9);
%     wat = watershed(gf, 'dynamic', 5);
%     show(wat==0)
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check image type
if ~strcmp(this.type, 'grayscale') && ~strcmp(this.type, 'intensity')
    error('Requires a Grayscale or intensity image to work');
end

% default values
dyn = [];
marker = [];
conn = 4;
if this.dimension == 3
    conn = 6;
end

% process input arguments
while ~isempty(varargin)
    var = varargin{1};
    
    if isnumeric(var) && isscalar(var)
        conn = var;
        varargin(1) = [];
        continue;
    end
    
    if ischar(var) && length(varargin) > 1
        switch lower(var)
            case 'conn'
                conn = varargin(2);
            case 'marker'
                marker = varargin{2};
            case 'dynamic'
                dyn = varargin{2};
            otherwise
                error('Unknown parameter name: %s', var);
        end
        varargin(1:2) = [];
    end
end

% if dynamic was specified, compute marker image
if ~isempty(dyn)
    marker = imextendedmin(this.data, dyn, conn);
end

% If markers are specified, impose minima on image
if isempty(marker)
    data = this.data;
else
    if isa(marker, 'Image')
        marker = marker.data;
    end
    data = imimposemin(this.data, marker, conn);
end

% Compute watershed
wat = watershed(data, conn);

% cast to integer
lmax = max(wat(:));
if lmax <= 255
    wat = uint8(wat);
elseif lmax < 2^16
    wat = uint16(wat);
elseif lmax < 2^32
    wat = uint32(wat);
end

% create result image
res = Image(this.dimension, 'data', wat, 'parent', this, 'type', 'label');
