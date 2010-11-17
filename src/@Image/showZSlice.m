function varargout = showZSlice(this, sliceIndex)
%SHOWZSLICE Show XY slice of a 3D image
%
%   img.showZSlice(INDEX)
%   showZSlice(IMG, INDEX)
%   Display the given slice as a 3D planar image. INDEX is the slice index,
%   between 0 and img.getSize(3)-1.
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
%   showXSlice, showYSlice, getSlice
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Extract image info

% compute voxel positions
lz = this.getZData();

dim = this.dataSize;
vx = ((0:dim(1))-.5)*this.calib.spacing(1) - this.calib.origin(1);
vy = ((0:dim(2))-.5)*this.calib.spacing(2) - this.calib.origin(2);

% % reverse z axis to have first slice on top
% set(gca, 'zdir', 'reverse');

% global parameters for surface display
params = {'facecolor','texturemap', 'edgecolor', 'none'};

% compute position of voxel vertices in 3D space
[xy_x xy_y] = meshgrid(vx, vy);
xy_z = ones(size(xy_x))*lz(sliceIndex+1);

% extract slice in z direction
slice = this.getSlice(3, sliceIndex);

% eventually converts to uint8, rescaling data between 0 and max value
if ~strcmp(class(slice), 'uint8')
    slice = double(slice);
    slice = uint8(slice*255/max(slice(:)));
end

% repeat slice three times to manage a color image
hs = surface(xy_x, xy_y, xy_z, ...
    repmat(slice, [1 1 3]), params{:});


%% process output arguments

if nargout>0
    varargout{1} = hs;
end
