function [res, labels] = regionIsosurfaces(obj, varargin)
% Generate isosurface of each region within a label image.
%
%   MESHES = regionIsosurfaces(LBL)
%   Computes isosurfaces of each region within the label image LBL.
%   
%
%   Example
%     markers = Image.true([50 50 50]);
%     n = 100;
%     rng(10);
%     seeds = randi(50, [n 3]);
%     for i = 1:n
%         markers(seeds(i,1), seeds(i,2), seeds(i,3)) = false;
%     end
%     wat = watershed(distanceMap(markers), 6);
%     wat2 = killBorders(wat);
%     figure; hold on; axis equal; 
%     regionIsosurfaces(wat2, 'smoothRadius', 2, 'LineStyle', 'none');
%     view(3), light;
%
%   See also
%     isosurface, gt
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-02-22,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE.


%% Input arguiment processing

% check if labels are specified
labels = [];
if ~isempty(varargin) && size(varargin{1}, 2) == 1
    labels = varargin{1};
    varargin(1) = [];
end

% extract the set of labels, without the background
if isempty(labels)
    labels = findRegionLabels(obj);
end
nLabels = length(labels);

% parse other options
smoothRadius = 0; 
siz = 0;
if ~isempty(varargin) && strcmpi(varargin{1}, 'smoothRadius')
    smoothRadius = varargin{2};
    if isscalar(smoothRadius)
        smoothRadius = smoothRadius([1 1 1]);
    end
    siz = floor(smoothRadius * 2) + 1;
    varargin(1:2) = [];
end


%% Preprocessing

% retrieve voxel coordinates in physical space
% (common to all labels)
x = getX(obj);
y = getY(obj);
z = getZ(obj);

% permute data to comply with Matlab orientation
v = permute(obj.Data(:,:,:,1,1), [2 1 3]);

% allocate memory for labels
meshes = cell(1, nLabels);


%% Isosurface computation

% iterate over regions to generate isosurfaces
for iLabel = 1:nLabels
    label = labels(iLabel);
    
    vol = double(v == label);
    % optional smoothing
    if smoothRadius > 0
        vol = filterData(vol, siz, smoothRadius);
    end
    
    meshes{iLabel} = isosurface(x, y, z, vol, 0.5);
end


%% Finalization

if nargout == 0
    % display isosurfaces
    for i = 1:nLabels
        patch(meshes{i}, varargin{:});
    end
    
else
    % return computed mesh list
    res = meshes;
end
end

%% Utility function
function data = filterData(data, kernelSize, sigma)
% process each direction
for i = 1:3
    % compute spatial reference
    refSize = (kernelSize(i) - 1) / 2;
    s0 = floor(refSize);
    s1 = ceil(refSize);
    lx = -s0:s1;
    
    % compute normalized kernel
    sigma2 = 2*sigma(i).^2;
    kernel = exp(-(lx.^2 / sigma2));
    kernel = kernel / sum(kernel);
    
    % reshape the kernel such as it is elongated in the i-th direction
    newDim = [ones(1, i-1) kernelSize(i) ones(1, 3-i)];
    kernel = reshape(kernel, newDim);
    
    % apply filtering along one direction
    data = imfilter(data, kernel, 'replicate');
end
end
