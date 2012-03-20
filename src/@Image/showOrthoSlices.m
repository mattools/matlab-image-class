function varargout = showOrthoSlices(this, varargin)
%SHOWORTHOSLICES Show three orthogonal slices in 3D
%
%   showOrthoSlices(IMG, POS)
%   POS is 1*3 row vector containing position of slices intersection point,
%   in image index coordinate between 0 and size(img)-1.
%
%   Example
%     img = Image.read('brainMRI.hdr');
%     figure(1); clf; hold on;
%     showOrthoSlices(img, [60 80 13]);
%     axis(physicalExtent(img));       % setup axis limits
%     axis equal;                      % to have equal sizes
%
%   See also
%   showXSlice, showYSlice, showZSlice, getSlice
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% if no position is specified, use the center of image
if isempty(varargin) || ischar(varargin{1})
    siz = this.dataSize;
    pos = floor(siz/2);
else
    pos = varargin{1};
    varargin(1) = [];
end

% extract user defined options
options = cell(1, 0);
while length(varargin) > 1
    paramName = varargin{1};
    switch lower(paramName)
        case 'displayrange'
            options = [options {'DisplayRange', varargin{2}}]; %#ok<AGROW>
        case {'lut', 'colormap'}
            options = [options {'ColorMap', varargin{2}}]; %#ok<AGROW>
        otherwise
            error(['Unknown parameter name: ' paramName]);
    end

    varargin(1:2) = [];
end


% display three mutually orthogonal 3D slices
hold on;
hyz = showSlice3d(this, 1, pos(1), options{:});
hxz = showSlice3d(this, 2, pos(2), options{:});
hxy = showSlice3d(this, 3, pos(3), options{:});

% use equal spacing by default
axis equal;

if nargout > 2
    varargout = {hxy, hyz, hxz};
end
