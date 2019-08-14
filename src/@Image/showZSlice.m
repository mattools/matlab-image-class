function varargout = showZSlice(obj, sliceIndex)
% Show XY slice of a 3D image.
%
%   img.showZSlice(INDEX)
%   showZSlice(IMG, INDEX)
%   Display the given sli as a 3D planar image. INDEX is the slice index,
%   between 1 and size(img, 3).
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
%     showXSlice, showYSlice, slice
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Extract image info

% compute voxel positions
lz = zData(obj);

dim = obj.DataSize;
vx = ((0:dim(1))-.5) * obj.Spacing(1) - obj.Origin(1);
vy = ((0:dim(2))-.5) * obj.Spacing(2) - obj.Origin(2);

% global parameters for surface display
params = {'facecolor', 'texturemap', 'edgecolor', 'none'};

% compute position of voxel vertices in 3D space
[xy_x, xy_y] = meshgrid(vx, vy);
xy_z = ones(size(xy_x)) * lz(sliceIndex);

% extract sli in z direction
sli = slice(obj, 3, sliceIndex);
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
hs = surface(xy_x, xy_y, xy_z, sli, params{:});


%% process output arguments

if nargout > 0
    varargout = {hs};
end
