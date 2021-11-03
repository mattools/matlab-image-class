function [surf, labels] = regionSurfaceArea(obj, varargin)
% Surface area of the regions within a 3D binary or label image.
%
%   S = regionSurfaceArea(IMG)
%   Estimates the surface area of the 3D binary structure represented by
%   IMG.
%
%   S = regionSurfaceArea(IMG, NDIRS)
%   Specifies the number of directions used for estimating surface area.
%   NDIRS can be either 3 or 13, default is 13.
%
%   S = regionSurfaceArea(..., SPACING)
%   Specifies the spatial calibration of the image. SPACING is a 1-by-3 row
%   vector containing the voxel size in the X, Y and Z directions, in that
%   orders. 
%
%   S = regionSurfaceArea(LBL)
%   [S, L] = imSurface(LBL)
%   When LBL is a label image, returns the surface area of each label in
%   the 3D array, and eventually returns the indices of processed labels.
%
%   S = regionSurfaceArea(..., LABELS)
%   In the case of a label image, specifies the labels of the region to
%   analyse.
%
%
%   Example
%     % Create a binary image of a ball
%     [x y z] = meshgrid(1:100, 1:100, 1:100);
%     img = Image(sqrt( (x-50.12).^2 + (y-50.23).^2 + (z-50.34).^2) < 40);
%     % compute surface area of the ball
%     S = regionSurfaceArea(img)
%     S =
%         2.0103e+04
%     % compare with theoretical value
%     Sth = 4*pi*40^2;
%     100 * (S - Sth) / Sth
%     ans = 
%         -0.0167
%
%     % compute surface area of several regions in a label image
%     img = Image(zeros([10 10 10]), 'Type', 'Label');
%     img(2:3, 2:3, 2:3) = 1;
%     img(5:8, 2:3, 2:3) = 2;
%     img(5:8, 5:8, 2:3) = 4;
%     img(2:3, 5:8, 2:3) = 3;
%     img(5:8, 5:8, 5:8) = 8;
%     [surfs, labels] = regionSurfaceArea(img)
%     surfs =
%        16.4774
%        29.1661
%        29.1661
%        49.2678
%        76.7824
%     labels =
%          1
%          2
%          3
%          4
%          8
%
%
%   See also
%     regionVolume, regionMeanBreadth, regionEulerNumber, regionPerimeter
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-11-02,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE.


%% Parse input arguments

% check image type
if ~(isLabelImage(obj) || isBinaryImage(obj))
    error('Requires a label of binary image');
end

% check dimensionality
nd = ndims(obj);
if nd ~= 3
    error('Requires a 3-dimensional image');
end

% default values of parameters
nDirs = 13;
labels = [];
% methods to compute direction weights. Can be {'Voronoi'}, 'isotropic'.
directionWeights = 'voronoi';

% Process user input arguments
while ~isempty(varargin)
    var1 = varargin{1};
    
    if isnumeric(var1)
        % option is either connectivity or resolution
        if isscalar(var1)
            nDirs = var1;
        elseif size(var1, 2) == 1
            labels = var1;
        end
        varargin(1) = [];
        
    elseif ischar(var1)
        if length(varargin) < 2
            error('optional named argument require a second argument as value');
        end
        if strcmpi(var1, 'directionweights')
            directionWeights = varargin{2};
        end
        varargin(1:2) = [];
        
    else
        error('option should be numeric');
    end
    
end


%% Process label images

if isBinaryImage(obj)
    % in case of binary image, compute only one label
    surf = surfaceAreaBinaryData(obj.Data, nDirs, obj.Spacing, directionWeights);
    labels = 1;
    
else
    % in case of a label image, return a vector with a set of results
    
    % extract labels if necessary (considers 0 as background)
    if isempty(labels)
        labels = findRegionLabels(obj);
    end
    
    % allocate result array
    nLabels = length(labels);
    surf = zeros(nLabels, 1);
    
    % compute bounding box of each region
    bounds = regionMinMaxIndices(obj, labels);
    
    % compute perimeter of each region considered as binary image
    for i = 1:nLabels
        label = labels(i);
        
        % convert bounding box to image extent, in x and y directions
        bx = bounds(i, [1 2]);
        by = bounds(i, [3 4]);
        bz = bounds(i, [5 6]);
        
        bin = obj.Data(bx(1):bx(2), by(1):by(2), bz(1):bz(2)) == label;
        surf(i) = surfaceAreaBinaryData(bin, nDirs, obj.Spacing, directionWeights);
    end
end


%% Process Binary data
function surf = surfaceAreaBinaryData(img, nDirs, spacing, directionWeights)

% distances between a pixel and its neighbours.
d1  = spacing(1); % x
d2  = spacing(2); % y
d3  = spacing(3); % z

% volume of a voxel (used for computing line densities)
vol = d1 * d2 * d3;


%% Main processing for 3 directions

% number of voxels
nv = sum(img(:));

% number of connected components along the 3 main directions
% (Use Graph-based formula: chi = nVertices - nEdges)
n1 = nv - sum(sum(sum(img(1:end-1,:,:) & img(2:end,:,:)))); % x
n2 = nv - sum(sum(sum(img(:,1:end-1,:) & img(:,2:end,:)))); % y
n3 = nv - sum(sum(sum(img(:,:,1:end-1) & img(:,:,2:end)))); % z

if nDirs == 3
    % compute surface area by averaging over the 3 main directions
    surf = 4/3 * (n1/d1 + n2/d2 + n3/d3) * vol;
    return;
end


%% Additional processing for 13 directions

% Number of connected components along diagonals contained in the three
% main planes
% XY planes
n4 = nv - sum(sum(sum(img(2:end,1:end-1,:)   & img(1:end-1,2:end,:))));
n5 = nv - sum(sum(sum(img(1:end-1,1:end-1,:) & img(2:end,2:end,:))));
% XZ planes
n6 = nv - sum(sum(sum(img(2:end,:,1:end-1)   & img(1:end-1,:,2:end))));
n7 = nv - sum(sum(sum(img(1:end-1,:,1:end-1) & img(2:end,:,2:end))));
% YZ planes
n8 = nv - sum(sum(sum(img(:,2:end,1:end-1)   & img(:,1:end-1,2:end))));
n9 = nv - sum(sum(sum(img(:,1:end-1,1:end-1) & img(:,2:end,2:end))));
% % XZ planes
% n6 = nv - sum(sum(sum(img(:,2:end,1:end-1)   & img(:,1:end-1,2:end))));
% n7 = nv - sum(sum(sum(img(:,1:end-1,1:end-1) & img(:,2:end,2:end))));
% % YZ planes
% n8 = nv - sum(sum(sum(img(2:end,:,1:end-1)   & img(1:end-1,:,2:end))));
% n9 = nv - sum(sum(sum(img(1:end-1,:,1:end-1) & img(2:end,:,2:end))));

% Number of connected components along lines corresponding to diagonals of
% the unit cube
n10 = nv - sum(sum(sum(img(1:end-1,1:end-1,1:end-1) & img(2:end,2:end,2:end))));
n11 = nv - sum(sum(sum(img(2:end,1:end-1,1:end-1) & img(1:end-1,2:end,2:end))));
n12 = nv - sum(sum(sum(img(1:end-1,2:end,1:end-1) & img(2:end,1:end-1,2:end))));
n13 = nv - sum(sum(sum(img(2:end,2:end,1:end-1) & img(1:end-1,1:end-1,2:end))));

% space between 2 voxels in each direction
d12  = hypot(d1, d2);
d13  = hypot(d1, d3);
d23  = hypot(d2, d3);
d123 = sqrt(d1^2 + d2^2 + d3^2);

% Compute weights corresponding to surface fraction of spherical caps
if strcmp(directionWeights, 'isotropic')
    c = zeros(13,1);
    c(1) = 0.04577789120476 * 2;  % Ox
    c(2) = 0.04577789120476 * 2;  % Oy
    c(3) = 0.04577789120476 * 2;  % Oz
    c(4:5)  = 0.03698062787608 * 2;  % Oxy
    c(6:7)  = 0.03698062787608 * 2;  % Oxz
    c(8:9)  = 0.03698062787608 * 2;  % Oyz
    c(10:13) = 0.03519563978232 * 2;  % Oxyz
    
else
    c = Image.directionWeights3d13(spacing);
end

% compute the weighted sum of each direction
% intersection count * direction weight / line density
surf = 4 * vol * (...
    n1*c(1)/d1 + n2*c(2)/d2 + n3*c(3)/d3 + ...
    (n4+n5)*c(4)/d12 + (n6+n7)*c(6)/d13 + (n8+n9)*c(8)/d23 + ...
    (n10 + n11 + n12 + n13)*c(10)/d123 );


