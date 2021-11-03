function [breadth, labels] = regionMeanBreadth(obj, varargin)
% Mean breadth of regions within a 3D binary or label image.
%
%   B = regionMeanBreadth(IMG)
%   Computes the mean breadth of the binary structure in IMG, or of each
%   particle in the label image IMG.
%
%   B = regionMeanBreadth(IMG, NDIRS)
%   Specifies the number of directions used for estimating the mean breadth
%   from the Crofton formula. Can be either 3 (the default) or 13.
%
%   B = regionMeanBreadth(..., SPACING)
%   Specifies the spatial calibration of the image. SPACING is a 1-by-3 row
%   vector containing the voxel size in the X, Y and Z directions, in that
%   orders. 
%
%   [B, LABELS]= regionMeanBreadth(LBL, ...)
%   Also returns the set of labels for which the mean breadth was computed.
%
%   Example
%     % define a ball from its center and a radius (use a slight shift to
%     % avoid discretisation artefacts)
%     xc = 50.12; yc = 50.23; zc = 50.34; radius = 40.0;
%     % Create a discretized image of the ball
%     [x y z] = meshgrid(1:100, 1:100, 1:100);
%     img = Image(sqrt( (x - xc).^2 + (y - yc).^2 + (z - zc).^2) < radius);
%     % compute mean breadth of the ball 
%     % (expected: the diameter of the ball)
%     b = regionMeanBreadth(img)
%     b =
%         80
%
%
%     % compute mean breadth of several regions in a label image
%     img = Image(zeros([10 10 10], 'uint8'), 'Type', 'Label');
%     img(2:3, 2:3, 2:3) = 1;
%     img(5:8, 2:3, 2:3) = 2;
%     img(5:8, 5:8, 2:3) = 4;
%     img(2:3, 5:8, 2:3) = 3;
%     img(5:8, 5:8, 5:8) = 8;
%     [breadths, labels] = regionMeanBreadth(img)
%     breadths =
%         2.1410
%         2.0676
%         2.0676
%         3.9942
%         4.9208
%     labels =
%          1
%          2
%          3
%          4
%          8
%
%   See also
%     regionVolume, regionsSurfaceArea, regionsEulerNumber, regionPerimeter
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
        
    else
        error('option should be numeric');
    end
    
end


%% Process label images

if isBinaryImage(obj)
    % in case of binary image, compute only one label
    breadth = meanBreadthBinaryData(obj.Data, nDirs, obj.Spacing);
    labels = 1;
    
else
    % in case of a label image, return a vector with a set of results
    
    % extract labels if necessary (considers 0 as background)
    if isempty(labels)
        labels = findRegionLabels(obj);
    end
    
    % allocate result array
    nLabels = length(labels);
    breadth = zeros(nLabels, 1);
    
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
        breadth(i) = meanBreadthBinaryData(bin, nDirs, obj.Spacing);
    end
end


%% Process Binary data
function breadth = meanBreadthBinaryData(img, nDirs, spacing)

%% Process binary images

% pre-compute distances between a pixel and its neighbours.
d1  = spacing(1);
d2  = spacing(2);
d3  = spacing(3);
vol = d1 * d2 * d3;

%% Main processing for 3 directions

% number of voxels
nv = sum(img(:));

% number of connected components along the 3 main directions
ne1 = sum(sum(sum(img(1:end-1,:,:) & img(2:end,:,:))));
ne2 = sum(sum(sum(img(:,1:end-1,:) & img(:,2:end,:))));
ne3 = sum(sum(sum(img(:,:,1:end-1) & img(:,:,2:end))));

% number of square faces on plane with normal directions 1 to 3
nf1 = sum(sum(sum(...
    img(:,1:end-1,1:end-1) & img(:,2:end,1:end-1) & ...
    img(:,1:end-1,2:end)   & img(:,2:end,2:end)     )));
nf2 = sum(sum(sum(...
    img(1:end-1,:,1:end-1) & img(2:end,:,1:end-1) & ...
    img(1:end-1,:,2:end)   & img(2:end,:,2:end)     )));
nf3 = sum(sum(sum(...
    img(1:end-1,1:end-1,:) & img(2:end,1:end-1,:) & ...
    img(1:end-1,2:end,:)   & img(2:end,2:end,:)     )));

% mean breadth in 3 main directions
b1 = nv - (ne2 + ne3) + nf1;
b2 = nv - (ne1 + ne3) + nf2;
b3 = nv - (ne1 + ne2) + nf3;

% inverse of planar density (in m = m^3/m^2) in each direction
a1 = vol / (d2 * d3);
a2 = vol / (d1 * d3);
a3 = vol / (d1 * d2);

if nDirs == 3
    breadth = (b1 * a1 + b2 * a2 + b3 * a3) / 3;
    return;
end


% number of connected components along the 6 planar diagonal 
ne4 = sum(sum(sum(img(1:end-1,1:end-1,:) & img(2:end,2:end,:))));
ne5 = sum(sum(sum(img(1:end-1,2:end,:) & img(2:end,1:end-1,:))));
ne6 = sum(sum(sum(img(1:end-1,:,1:end-1) & img(2:end,:,2:end))));
ne7 = sum(sum(sum(img(1:end-1,:,2:end) & img(2:end,:,1:end-1))));
ne8 = sum(sum(sum(img(:,1:end-1,1:end-1,:) & img(:,2:end,2:end))));
ne9 = sum(sum(sum(img(:,1:end-1,2:end,:) & img(:,2:end,1:end-1))));

% number of square faces on plane with normal directions 4 to 9
nf4 = sum(sum(sum(...
    img(2:end,1:end-1,1:end-1) & img(1:end-1,2:end,1:end-1) & ...
    img(2:end,1:end-1,2:end)   & img(1:end-1,2:end,2:end)    )));
nf5 = sum(sum(sum(...
    img(1:end-1,1:end-1,1:end-1) & img(2:end,2:end,1:end-1) & ...
    img(1:end-1,1:end-1,2:end)   & img(2:end,2:end,2:end)    )));

nf6 = sum(sum(sum(...
    img(2:end,1:end-1,1:end-1) & img(2:end,2:end,1:end-1) & ...
    img(1:end-1,1:end-1,2:end) & img(1:end-1,2:end,2:end)  )));
nf7 = sum(sum(sum(...
    img(1:end-1,1:end-1,1:end-1) & img(1:end-1,2:end,1:end-1) & ...
    img(2:end,1:end-1,2:end)     & img(2:end,2:end,2:end)  )));

nf8 = sum(sum(sum(...
    img(1:end-1,2:end,1:end-1) & img(2:end,2:end,1:end-1) & ...
    img(1:end-1,1:end-1,2:end) & img(2:end,1:end-1,2:end)    )));
nf9 = sum(sum(sum(...
    img(1:end-1,1:end-1,1:end-1) & img(2:end,1:end-1,1:end-1) & ...
    img(1:end-1,2:end,2:end) & img(2:end,2:end,2:end)    )));

b4 = nv - (ne5 + ne3) + nf4;
b5 = nv - (ne4 + ne3) + nf5;
b6 = nv - (ne7 + ne2) + nf6;
b7 = nv - (ne6 + ne2) + nf7;
b8 = nv - (ne9 + ne1) + nf8;
b9 = nv - (ne8 + ne1) + nf9;

% number of triangular faces on plane with normal directions 10 to 13
nf10 = sum(sum(sum(...
    img(2:end,1:end-1,1:end-1) & img(1:end-1,2:end,1:end-1) & ...
    img(1:end-1,1:end-1,2:end)    ))) ...
    + sum(sum(sum(...
    img(2:end,2:end,1:end-1) & img(1:end-1,2:end,2:end) & ...
    img(2:end,1:end-1,2:end)    ))) ;

nf11 = sum(sum(sum(...
    img(1:end-1,1:end-1,1:end-1) & img(2:end,2:end,1:end-1) & ...
    img(2:end,1:end-1,2:end)    ))) ...
    + sum(sum(sum(...
    img(1:end-1,2:end,1:end-1) & img(1:end-1,1:end-1,2:end) & ...
    img(2:end,2:end,2:end)    ))) ;

nf12 = sum(sum(sum(...
    img(1:end-1,1:end-1,1:end-1) & img(2:end,2:end,1:end-1) & ...
    img(1:end-1,2:end,2:end)    ))) ...
    + sum(sum(sum(...
    img(2:end,1:end-1,1:end-1) & img(1:end-1,1:end-1,2:end) & ...
    img(2:end,2:end,2:end)    ))) ;

nf13 = sum(sum(sum(...
    img(2:end,1:end-1,1:end-1) & img(1:end-1,2:end,1:end-1) & ...
    img(2:end,2:end,2:end)  )))   ...
    + sum(sum(sum(...
    img(1:end-1,1:end-1,1:end-1) & img(2:end,1:end-1,2:end) & ...
    img(1:end-1,2:end,2:end)    ))) ;

% length of diagonals
d12 = hypot(d1, d2);
d13 = hypot(d1, d3);
d23 = hypot(d2, d3);

% inverse of planar density (in m = m^3/m^2) in directions 4 to 13
a4 = vol / (d3 * d12);
a6 = vol / (d2 * d13);
a8 = vol / (d1 * d23);

% compute area of diagonal triangle via Heron's formula
s  = (d12 + d13 + d23) / 2;
a10 = vol / (2 * sqrt( s * (s-d12) * (s-d13) * (s-d23) ));


b10 = nv - (ne5 + ne7 + ne9) + nf10;
b11 = nv - (ne4 + ne6 + ne9) + nf11;
b12 = nv - (ne4 + ne7 + ne8) + nf12;
b13 = nv - (ne5 + ne6 + ne8) + nf13;

if nDirs ~= 13
    error('Unknown number of directions');
end

c = Image.directionWeights3d13(spacing);

% weighted average over directions
breadth = ...
    (b1*c(1)*a1 + b2*c(2)*a2 + b3*c(3)*a3) + ...
    ((b4+b5)*c(4)*a4 + (b6+b7)*c(6)*a6 + (b8+b9)*c(8)*a8) + ...
    ((b10 + b11 + b12 + b13)*c(10)*a10) ;
