function varargout = showYSlice(this, sliceIndex)
%SHOWYSLICE Show XZ slice of a 3D image
%
%   showYSlice(IMG, INDEX)
%   IMG.showYSlice(INDEX)
%   Display the given slice as a 3D planar image. INDEX is the slice index,
%   between 1 and size(img, 2).
%
%   Example
%   % Display 3 orthoslices of a humain head
%     img = Image.read('brainMRI.hdr');
%     figure(1); clf; hold on;
%     showZSlice(img, 13);
%     showXSlice(img, 60);
%     showYSlice(img, 80);
%     axis(physicalExtent(img));
%     view(3);
%     xlabel('x'); ylabel('y'); zlabel('z');
%
%
%   See also
%   showXSlice, showZSlice, slice
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Extract image info

% compute voxel positions
ly = yData(this);

dim = this.dataSize;
vx = ((0:dim(1))-.5) * this.spacing(1) - this.origin(1);
vz = ((0:dim(3))-.5) * this.spacing(3) - this.origin(3);

% global parameters for surface display
params = {'facecolor', 'texturemap', 'edgecolor', 'none'};

% compute position of voxel vertices in 3D space
[xz_x, xz_z] = meshgrid(vx, vz);
xz_y = ones(size(xz_x)) * ly(sliceIndex);

% extract sli in Y direction
sli = slice(this, 2, sliceIndex);
sli = getBuffer(squeeze(sli));

% eventually converts to uint8, rescaling data between 0 and max value
if ~isa(sli, 'uint8')
    sli = double(sli);
    sli = uint8(sli * 255 / max(sli(:)));
end

% convert grayscale to rgb (needed by 'surface' function)
if length(size(sli)) == 2
    sli = repmat(sli, [1 1 3]);
end

% display voxel values in appropriate reference space
hs = surface(xz_x, xz_y, xz_z, sli, params{:});


%% process output arguments

if nargout > 0
    varargout = {hs};
end
