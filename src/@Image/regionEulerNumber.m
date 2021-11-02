function [chi, labels] = regionEulerNumber(obj, varargin)
% Euler number of a binary or label image.
%
%   The function computes the Euler number, or Euler-Poincare
%   characteristic, of a binary 2D image. The result corresponds to the
%   number of connected components, minus the number of holes in the image.
%
%   CHI = regionEulerNumber(IMG);
%   Return the Euler-Poincaré Characteristic of the binary structure within
%   the image IMG.
%
%   CHI = regionEulerNumber(IMG, CONN);
%   Specifies the connectivity used. Currently 4 and 8 connectivities are
%   supported.
%
%   Example
%     img = Image.read('coins.png');
%     bin = closing(img>80, ones(3,3));
%     regionEulerNumber(bin)
%     ans = 
%         10
%
%   See Also:
%     regionArea, regionPerimeter, regionprops
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

% check image dimension
if ndims(obj) ~= 2 %#ok<ISMAT>
    error('First argument should be a 2D image');
end

% default options
labels = [];
conn = 4;

% parse input arguments
while ~isempty(varargin)
    var1 = varargin{1};
    varargin(1) = [];
    
    if isscalar(var1)
        % connectivity
        conn = var1;
    elseif size(var1, 2) == 1
        % the labels to compute
        labels = var1;
    else
        error('Unable to interpret input argument');
    end
end


%% Process label image

if isBinaryImage(obj)
     % in case of binary image, compute only one label
     chi = eulerNumberBinary2d(obj.Data, conn);
     labels = 1;

elseif isLabelImage(obj)
    % in case of a label image, return a vector with a set of results.
    
    % extract labels if necessary (considers 0 as background)
    if isempty(labels)
        labels = findRegionLabels(obj);
    end
    
    % allocate result array
    nLabels = length(labels);
    chi = zeros(nLabels, 1);
    
    % compute bounding box of each region
    bounds = regionMinMaxIndices(obj, labels);
    
    % compute Euler number of each label considered as binary image
    for i = 1:nLabels
        label = labels(i);
        
        % convert bounding box to image extent, in x and y directions
        i0 = bounds(i, [1 3]);
        i1 = bounds(i, [2 4]);
        
        bin = obj.Data(i0(1):i1(1), i0(2):i1(2)) == label;
        chi(i) = eulerNumberBinary2d(bin, conn);
    end
else
    error('Wrong type of image');
end


%% Process 2D binary image
function chi = eulerNumberBinary2d(img, conn)
% Compute euler number on a 3D binary image.
%
% Axis order of array follow physical order: X, Y.
%

% size of image in each direction
N1 = size(img, 1);
N2 = size(img, 2);

% compute number of nodes, number of edges (H and V) and number of faces.
% principle is erosion with simple structural elements (line, square)
% but it is replaced here by simple boolean operation, which is faster

% count vertices
n = sum(img(:));

% count horizontal and vertical edges
n1 = sum(sum(img(1:N1-1,:) & img(2:N1,:)));
n2 = sum(sum(img(:,1:N2-1) & img(:,2:N2)));

% count square faces
n1234 = sum(sum(...
    img(1:N1-1,1:N2-1) & img(1:N1-1,2:N2) & ...
    img(2:N1,1:N2-1)   & img(2:N1,2:N2) ));

if conn == 4
    % compute euler characteristics from graph counts
    chi = n - n1 - n2 + n1234;
    return;
    
elseif conn == 8    
    % For 8-connectivity, need also to count diagonal edges
    n3 = sum(sum(img(1:N1-1,1:N2-1) & img(2:N1,2:N2)));
    n4 = sum(sum(img(1:N1-1,2:N2)   & img(2:N1,1:N2-1)));
    
    % and triangular faces
    n123 = sum(sum(img(1:N1-1,1:N2-1) & img(1:N1-1,2:N2) & img(2:N1,1:N2-1) ));
    n124 = sum(sum(img(1:N1-1,1:N2-1) & img(1:N1-1,2:N2) & img(2:N1,2:N2) ));
    n134 = sum(sum(img(1:N1-1,1:N2-1) & img(2:N1,1:N2-1) & img(2:N1,2:N2) ));
    n234 = sum(sum(img(1:N1-1,2:N2)   & img(2:N1,1:N2-1) & img(2:N1,2:N2) ));
    
    % compute euler characteristics from graph counts
    % chi = Nvertices - Nedges + Ntriangles + Nsquares
    chi = n - (n1+n2+n3+n4) + (n123+n124+n134+n234) - n1234;
    
else
    error('regionEulerNumber: uknown connectivity option');
end
