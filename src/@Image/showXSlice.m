function varargout = showXSlice(obj, sliceIndex)
% Show YZ slice of a 3D image.
%
%   img.showXSlice(INDEX)
%   showXSlice(IMG, INDEX)
%   Display the given slice as a 3D planar image. INDEX is the slice index,
%   between 1 and size(img, 1).
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
%   See also
%     showYSlice, showZSlice, slice
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Extract image info

% compute voxel positions
lx = xData(obj);

dim = obj.DataSize;
vy = ((0:dim(2))-.5) * obj.Spacing(2) - obj.Origin(2);
vz = ((0:dim(3))-.5) * obj.Spacing(3) - obj.Origin(3);

% global parameters for surface display
params = {'facecolor', 'texturemap', 'edgecolor', 'none'};

% compute position of voxel vertices in 3D space
[yz_y, yz_z] = meshgrid(vy, vz);
yz_x = ones(size(yz_y)) * lx(sliceIndex);

% extract slice in x direction
sli = slice3d(obj, 1, sliceIndex);
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
hs = surface(yz_x, yz_y, yz_z, sli, params{:});


%% process output arguments

if nargout > 0
    varargout = {hs};
end
