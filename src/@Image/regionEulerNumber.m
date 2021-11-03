function [chi, labels] = regionEulerNumber(obj, varargin)
% Euler number of regions within a binary or label image.
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
%     regionArea, regionPerimeter, regionSurfaceArea, regionprops
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
nd = ndims(obj);
if nd == 2
    conn = 4;
elseif nd == 3
    conn = 6;
else
    error('First argument should be a 2D or a 3D image');
end

% default options
labels = [];


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
     if nd == 2
         chi = eulerNumberBinary2d(obj.Data, conn);
     else
         chi = eulerNumberBinary3d(obj.Data, conn);
     end
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
    if nd == 2
        for i = 1:nLabels
            label = labels(i);

            % convert bounding box to image extent, in x and y directions
            bx = bounds(i, [1 2]);
            by = bounds(i, [3 4]);
            
            bin = obj.Data(bx(1):bx(2), by(1):by(2)) == label;

            chi(i) = eulerNumberBinary2d(bin, conn);
        end
    else
        for i = 1:nLabels
            label = labels(i);
            
            % convert bounding box to image extent, in x and y directions
            bx = bounds(i, [1 2]);
            by = bounds(i, [3 4]);
            bz = bounds(i, [5 6]);
            
            bin = obj.Data(bx(1):bx(2), by(1):by(2), bz(1):bz(2)) == label;
            chi(i) = eulerNumberBinary3d(bin, conn);
        end
    end
else
    error('Wrong type of image');
end


%% Process 2D binary image
function chi = eulerNumberBinary2d(img, conn)
% Compute euler number on a 2D binary image.
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

%% Process 3D binary image
function chi = eulerNumberBinary3d(img, conn)
% Compute euler number on a 3D binary image.

% size of image in each direction
dim = size(img);
N1 = dim(1); 
N2 = dim(2);
N3 = dim(3);

% compute number of nodes, number of edges in each direction, number of
% faces in each plane, and number of cells.
% principle is erosion with simple structural elements (line, square)
% but it is replaced here by simple boolean operation, which is faster

% count vertices
v = sum(img(:));

% count edges in each direction
e1 = sum(sum(sum(img(1:N1-1,:,:) & img(2:N1,:,:))));
e2 = sum(sum(sum(img(:,1:N2-1,:) & img(:,2:N2,:))));
e3 = sum(sum(sum(img(:,:,1:N3-1,:) & img(:,:,2:N3))));

% count square faces orthogonal to each main directions
f1 = sum(sum(sum(...
    img(:, 1:N2-1, 1:N3-1) & img(:, 1:N2-1, 2:N3) & ...
    img(:, 2:N2, 1:N3-1)   & img(:, 2:N2, 2:N3) )));
f2 = sum(sum(sum(...
    img(1:N1-1, :, 1:N3-1) & img(1:N1-1, :, 2:N3) & ...
    img(2:N1, :, 1:N3-1)   & img(2:N1, :, 2:N3) )));
f3 = sum(sum(sum(...
    img(1:N1-1, 1:N2-1, :) & img(1:N1-1, 2:N2, :) & ...
    img(2:N1, 1:N2-1, :)   & img(2:N1, 2:N2, :) )));

% compute number of cubes
s = sum(sum(sum(...
    img(1:N1-1, 1:N2-1, 1:N3-1) & img(1:N1-1, 2:N2, 1:N3-1) & ...
    img(2:N1, 1:N2-1, 1:N3-1)   & img(2:N1, 2:N2, 1:N3-1) & ...
    img(1:N1-1, 1:N2-1, 2:N3)   & img(1:N1-1, 2:N2, 2:N3) & ...
    img(2:N1, 1:N2-1, 2:N3)     & img(2:N1, 2:N2, 2:N3) )));

if conn == 6
    % compute euler characteristics using graph formula
    chi = v - (e1+e2+e3) + (f1+f2+f3) - s;
    return;
    
elseif conn == 26
    
    % compute EPC inside image, with correction on edges
    % Compute the map of 2-by-2-by-2 configurations within image
    configMap =   img(1:N1-1,  1:N2-1, 1:N3-1) + ...
                2*img(2:N1,    1:N2-1, 1:N3-1) + ...
                4*img(1:N1-1,  2:N2,   1:N3-1) + ...
                8*img(2:N1,    2:N2,   1:N3-1) + ...
               16*img(1:N1-1,  1:N2-1, 2:N3) + ...
               32*img(2:N1,    1:N2-1, 2:N3) + ...
               64*img(1:N1-1,  2:N2,   2:N3) + ...
              128*img(2:N1,    2:N2,   2:N3);
    % Compute histogram of configurations
    histo = histcounts(configMap(:), 'BinLimits', [0 255], 'BinMethod', 'integers');
    % mutliplies by pre-computed contribution of each configuration
    epcc = sum(histo .* eulerLutC26());
    
    % Compute edge correction, in order to compensate it and obtain the
    % Euler-Poincare characteristic computed for whole image.
    
    % compute epc on faces   % 4
    f10  = imEuler2dC8(squeeze(img(1,:,:)));
    f11  = imEuler2dC8(squeeze(img(N1,:,:)));
    f20  = imEuler2dC8(squeeze(img(:,1,:)));
    f21  = imEuler2dC8(squeeze(img(:,N2,:)));
    f30  = imEuler2dC8(img(:,:,1));
    f31  = imEuler2dC8(img(:,:,N3));
    epcf = f10 + f11 + f20 + f21 + f30 + f31;
    
    % compute epc on edges  % 24
    e11 = imEuler1d(img(:,1,1));
    e12 = imEuler1d(img(:,1,N3));
    e13 = imEuler1d(img(:,N2,1));
    e14 = imEuler1d(img(:,N2,N3));
    
    e21 = imEuler1d(img(1,:,1));
    e22 = imEuler1d(img(1,:,N3));
    e23 = imEuler1d(img(N1,:,1));
    e24 = imEuler1d(img(N1,:,N3));
    
    e31 = imEuler1d(img(1,1,:));
    e32 = imEuler1d(img(1,N2,:));
    e33 = imEuler1d(img(N1,1,:));
    e34 = imEuler1d(img(N1,N2,:));
    
    epce = e11 + e12 + e13 + e14 + e21 + e22 + e23 + e24 + ...
        e31 + e32 + e33 + e34;
    
    % compute epc on vertices
    epcn = img(1,1,1) + img(1,1,N3) + img(1,N2,1) + img(1,N2,N3) + ...
        img(N1,1,1) + img(N1,1,N3) + img(N1,N2,1) + img(N1,N2,N3);
    
    % compute epc from measurements made on interior of window, and
    % facets of lower dimension
    chi = epcc + ( epcf/2 - epce/4 + epcn/8);
    
else
    error('imEuler3d: uknown connectivity option');
end

function tab = eulerLutC26
% Return the pre-computed array of Euler number contribution of each
% 2-by-2-by-2 configuration
tab = [...
  0   1   1   0   1   0  -2  -1   1  -2   0  -1   0  -1  -1   0 ...
  1   0  -2  -1  -2  -1  -1  -2  -6  -3  -3  -2  -3  -2   0  -1 ...
  1  -2   0  -1  -6  -3  -3  -2  -2  -1  -1  -2  -3   0  -2  -1 ...
  0  -1  -1   0  -3  -2   0  -1  -3   0  -2  -1   0   1   1   0 ...
  1  -2  -6  -3   0  -1  -3  -2  -2  -1  -3   0  -1  -2  -2  -1 ...
  0  -1  -3  -2  -1   0   0  -1  -3   0   0   1  -2  -1   1   0 ...
 -2  -1  -3   0  -3   0   0   1  -1   4   0   3   0   3   1   2 ...
 -1  -2  -2  -1  -2  -1   1   0   0   3   1   2   1   2   2   1 ...
  1  -6  -2  -3  -2  -3  -1   0   0  -3  -1  -2  -1  -2  -2  -1 ...
 -2  -3  -1   0  -1   0   4   3  -3   0   0   1   0   1   3   2 ...
  0  -3  -1  -2  -3   0   0   1  -1   0   0  -1  -2   1  -1   0 ...
 -1  -2  -2  -1   0   1   3   2  -2   1  -1   0   1   2   2   1 ...
  0  -3  -3   0  -1  -2   0   1  -1   0  -2   1   0  -1  -1   0 ...
 -1  -2   0   1  -2  -1   3   2  -2   1   1   2  -1   0   2   1 ...
 -1   0  -2   1  -2   1   1   2  -2   3  -1   2  -1   2   0   1 ...
  0  -1  -1   0  -1   0   2   1  -1   2   0   1   0   1   1   0 ...
] / 8;


function chi = imEuler2dC8(img)

% size of image in each direction
dim = size(img);
N1 = dim(1); 
N2 = dim(2);

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

% For 8-connectivity, need also to count diagonal edges
n3 = sum(sum(img(1:N1-1,1:N2-1) & img(2:N1,2:N2)));
n4 = sum(sum(img(1:N1-1,2:N2)   & img(2:N1,1:N2-1)));

% and triangular faces
n123 = sum(sum(img(1:N1-1,1:N2-1) & img(1:N1-1,2:N2) & img(2:N1,1:N2-1) ));
n124 = sum(sum(img(1:N1-1,1:N2-1) & img(1:N1-1,2:N2) & img(2:N1,2:N2) ));
n134 = sum(sum(img(1:N1-1,1:N2-1) & img(2:N1,1:N2-1) & img(2:N1,2:N2) ));
n234 = sum(sum(img(1:N1-1,2:N2)   & img(2:N1,1:N2-1) & img(2:N1,2:N2) ));

% compute Eeuler characteristics from graph counts
% chi = Nvertices - Nedges + Ntriangles + Nsquares
chi = n - (n1+n2+n3+n4) + (n123+n124+n134+n234) - n1234;


function chi = imEuler1d(img)
% Compute Euler number of a binary 1D image.
chi = sum(img(:)) - sum(img(1:end-1) & img(2:end));

