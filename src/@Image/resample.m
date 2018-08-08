function res = resample(this, varargin)
%RESAMPLE Resample this image with a new coordinate basis
%
%   RES = resample(IMG, LX, LY);
%   RES = resample(IMG, LX, LY, LZ);
%
%   Example
%   resample
%
%   See also
%     resize, interp
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-08-08,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

% info about current image
nd = this.dimension;

if isa(varargin{1}, 'Image')
    % if first argument is an image, extract its basis
    img2 = varargin{1};
    lx = xData(img2);
    ly = yData(img2);
    if nd == 2
        if img2.dimension ~= 2
            error('Image dimension must agree');
        end
        lz = zData(img2);
    end
    varargin(1) = [];
    
else
    % extract space basis from a list of vectors
    lx = varargin{1};
    ly = varargin{2};
    if nd == 2
        varargin(1:2) = [];
    else
        lz = varargin{3};
        varargin(1:3) = [];
    end
end


% create new basis 
if nd == 2
    [x, y] = meshgrid(lx, ly);
    res = interp(this, x, y, varargin{:});

    % convert to Image class
    res = Image('data', res, 'parent', this, ...
        'origin', [lx(1) ly(1)], ...
        'spacing', [lx(2)-lx(1) ly(2)-ly(1)]);
    
elseif nd == 3
    [x, y, z] = meshgrid(lx, ly, lz);
    res = interp(this, x, y, z, varargin{:});
    
    % convert to Image class
    res = Image('data', res, 'parent', this, ...
        'origin', [lx(1) ly(1) lz(1)], ...
        'spacing', [lx(2)-lx(1) ly(2)-ly(1) lz(2)-lz(1)]);
else
    error('Image must be 2D or 3D');
end
