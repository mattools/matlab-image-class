function varargout = showXSlice(this, sliceIndex)
%SHOWXSLICE Show YZ slice of a 3D image
%
%   img.showXSlice(INDEX)
%   showXSlice(IMG, INDEX)
%   Display the given slice as a 3D planar image. INDEX is the slice index,
%   between 0 and img.getSize(1)-1.
%
%   Example
%   % Display orthoslices of a humain head
%   I = analyze75read(analyze75info('brainMRI.hdr'));
%   img = Image3D(I);
%   figure(1); clf; hold on;
%   img.showZSlice(13);
%   img.showXSlice(60);
%   img.showYSlice(80);
%   axis(img.getPhysicalExtent());
%   xlabel('x'); ylabel('y'); zlabel('z');
%
%   See also
%   showYSlice, showZSlice, getSlice
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Extract image info

% compute voxel positions
lx = this.getXPositions();

dim = this.dataSize;
vy = ((0:dim(2))-.5)*this.calib.spacing(2) - this.calib.origin(2);
vz = ((0:dim(3))-.5)*this.calib.spacing(3) - this.calib.origin(3);

% % reverse z axis to have first slice on top
% set(gca, 'zdir', 'reverse');

% global parameters for surface display
params = {'facecolor','texturemap', 'edgecolor', 'none'};

% compute position of voxel vertices in 3D space
[yz_y yz_z] = meshgrid(vy, vz);
yz_x = ones(size(yz_y))*lx(sliceIndex+1);

% extract slice in z direction
slice = this.getSlice(1, sliceIndex);

% eventually converts to uint8, rescaling data between 0 and max value
if ~strcmp(class(slice), 'uint8')
    slice = double(slice);
    slice = uint8(slice*255/max(slice(:)));
end

% repeat slice three times to manage a color image
hs = surface(yz_x, yz_y, yz_z, ...
    repmat(slice, [1 1 3]), params{:});


%% process output arguments

if nargout>0
    varargout{1} = hs;
end
