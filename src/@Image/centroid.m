function [points, labs] = centroid(obj, varargin)
%CENTROID Centroid(s) of a binary or label image.
%
%   C = centroid(I)
%   Returns the centroid C of the binary image I. C is a 1-by-2 or 1-by-3
%   row vector, depending on the dimension of the image.
%
%   C = centroid(LBL)
%   If LBL is a label D-dimensional image, returns an array of N-by-D
%   values, corresponding to the centroid values of the N regions within
%   the image.
%
%   [C, LABELS] = centroid(LBL)
%   Also returns the labels of the regions that were measured.
%
%   Example
%     % Compute centroids of coins particles
%     img = Image.read('coins.png');            % read image
%     bin = opening(img > 80, ones([3 3]));     % binarize
%     lbl = labeling(bin);                      % compute labels
%     figure; show(img);                        % display image
%     pts = centroid(lbl);                      % compute centroids
%     hold on; plot(pts(:,1), pts(:,2), 'b+');  % display centroid
%
%   See also
%     analyzeRegions
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-07-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

% check image type
if ~(isLabelImage(obj) || isBinaryImage(obj))
    error('Requires a label of binary image');
end

% check if labels are specified
labels = [];
if ~isempty(varargin) && size(varargin{1}, 2) == 1
    labels = varargin{1};
end

% extract the set of labels, without the background
if isempty(labels)
    labels = findLabels(obj);
end
nLabels = length(labels);

% allocate memory for result
nd = ndims(obj);
points = zeros(nLabels, nd);

% switch processing depending on image dimensionality
if nd == 2
    for i = 1:nLabels
        % extract points of the current particle
        [x, y] = find(obj.Data == labels(i));

        % coordinates of particle centroid
        xc = mean(x);
        yc = mean(y);

        points(i, :) = [xc yc];
    end
  
elseif nd == 3
    dim = size(obj.Data);
    for i = 1:nLabels
        % extract points of the current particle
        inds = find(obj.Data == labels(i));
        [x, y, z] = ind2sub(dim, inds);

        % coordinates of particle centroid
        xc = mean(x);
        yc = mean(y);
        zc = mean(z);

        points(i, :) = [xc yc zc];
    end
    
else
    error('Requires an image of dimension 2 or 3');
end

if nargout > 1
    labs = labels;
end
