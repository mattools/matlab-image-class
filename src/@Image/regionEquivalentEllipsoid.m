function [ellipsoid, labels] = regionEquivalentEllipsoid(obj, varargin)
% Equivalent ellipsoid of region(s) in a 3D binary or label image.
%
%   ELLI = regionEquivalentEllipsoid(IMG)
%   Where IMG is a binary image of a single region.
%   ELLI = [XC YC ZC A B C PHI THETA PSI] is an ellipsoid defined by its
%   center [XC YC ZC], 3 radiusses A, B anc C, and a 3D orientation angle
%   given by (PHI, THETA, PSI).
%
%   ELLI = regionEquivalentEllipsoid(LBL)
%   Compute the ellipsoid with same second order moments for each region in
%   label image LBL. If the case of a binary image, a single ellipsoid
%   corresponding to the foreground (i.e. to the region with voxel value 1)
%   will be computed. 
%   The result ELLI is NL-by-9 array, with NL being the number of unique
%   labels in the input image.
%
%   ELLI = regionEquivalentEllipsoid(..., LABELS)
%   Specify the labels for which the ellipsoid needs to be computed. The
%   result is a N-by-9 array with as many rows as the number of labels.
%
%   Example
%     % Generate an ellipsoid image and computes the equivalent ellipsoid
%     % (one expects to obtain nearly same results)
%     elli = [50 50 50   50 30 10  40 30 20];
%     img = Image(discreteEllipsoid(1:100, 1:100, 1:100, elli));
%     elli2 = regionEquivalentEllipsoid(img)
%     elli2 =
%       50.00  50.00  50.00  50.0072  30.0032  10.0072  40.0375  29.9994  20.0182
%
%     % Draw equivalent ellipsoid of human head image
%     % (requires image processing toolbox, and slicer program for display)
%     img = Image.read('brainMRI.hdr');
%     img.Spacing = [1 1 2.5]; % fix spacing for display
%     bin = closing(img > 0, ones([3 3 3]));
%     figure; showOrthoSlices(img, [60 80 13]);
%     axis equal; view(3);
%     elli = regionEquivalentEllipsoid(bin);
%     drawEllipsoid(elli, 'FaceAlpha', 0.5) % requires MatGeom library
%     
%   See also
%     regionEquivalentEllipse, regionBoundingBox, regionCentroid
%     drawEllipsoid, regionprops3
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-11-03,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE.


%% check image type and dimension
if ~(isBinaryImage(obj) || isLabelImage(obj))
    error('Requires a label of binary image');
end
if ndims(obj) ~= 3
    error('Requires a 3D image');
end


%% Retrieve spatial calibration

% extract calibration
spacing = obj.Spacing;
origin  = obj.Origin;
dim = size(obj);


%% Initialisations

% check if labels are specified
labels = [];
if ~isempty(varargin) && size(varargin{1}, 2) == 1
    labels = varargin{1};
end

% extract the set of labels, without the background
if isempty(labels)
    labels = findRegionLabels(obj);
end

% allocate memory for result
nLabels = length(labels);
ellipsoid = zeros(nLabels, 9);

for i = 1:nLabels
    % extract position of voxels for the current region
    inds = find(obj.Data == labels(i));
    if isempty(inds)
        continue;
    end
    [x, y, z] = ind2sub(dim, inds);
    
    % compute approximate location of ellipsoid center
    xc = mean(x);
    yc = mean(y);
    zc = mean(z);
    
    % compute center (in pixel coordinates)
    center = [xc yc zc];
    
    % recenter points (should be better for numerical accuracy)
    x = (x - xc) * spacing(1);
    y = (y - yc) * spacing(2);
    z = (z - zc) * spacing(3);
    
    points = [x y z];
    
    % compute the covariance matrix
    covPts = cov(points, 1) + diag(spacing.^2 / 12);
    
    % perform a principal component analysis with 3 variables,
    % to extract equivalent axes
    [U, S] = svd(covPts);
    
    % extract length of each semi axis
    radii = sqrt(5) * sqrt(diag(S))';
    
    % sort axes from greater to lower
    [radii, ind] = sort(radii, 'descend');
    
    % format U to ensure first axis points to positive x direction
    U = U(ind, :);
    if U(1,1) < 0
        U = -U;
        % keep matrix determinant positive
        U(:,3) = -U(:,3);
    end
    
    % convert axes rotation matrix to Euler angles
    angles = rotation3dToEulerAngles(U);
    
    % concatenate result to form an ellipsoid object
    center = (center - 1) .* spacing + origin;
    ellipsoid(i, :) = [center radii angles];
end


function varargout = rotation3dToEulerAngles(mat)
% Extract Euler angles from a rotation matrix.
%
%   [PHI, THETA, PSI] = rotation3dToEulerAngles(MAT)
%   Computes Euler angles PHI, THETA and PSI (in degrees) from a 3D 4-by-4
%   or 3-by-3 rotation matrix.
%
%   ANGLES = rotation3dToEulerAngles(MAT)
%   Concatenates results in a single 1-by-3 row vector. This format is used
%   for representing some 3D shapes like ellipsoids.
%
%   Example
%   rotation3dToEulerAngles
%
%   References
%   Code from Graphics Gems IV on euler angles
%   http://tog.acm.org/resources/GraphicsGems/gemsiv/euler_angle/EulerAngles.c
%   Modified using explanations in:
%   http://www.gregslabaugh.name/publications/euler.pdf
%
%   See also
%   MatGeom library

% conversion from radians to degrees
k = 180 / pi;

% extract |cos(theta)|
cy = hypot(mat(1, 1), mat(2, 1));

% avoid dividing by 0
if cy > 16*eps
    % normal case: theta <> 0
    psi     = k * atan2( mat(3, 2), mat(3, 3));
    theta   = k * atan2(-mat(3, 1), cy);
    phi     = k * atan2( mat(2, 1), mat(1, 1));
else
    % theta close to 0
    psi     = k * atan2(-mat(2, 3), mat(2, 2));
    theta   = k * atan2(-mat(3, 1), cy);
    phi     = 0;
end

% format output arguments
if nargout <= 1
    % one array
    varargout{1} = [phi theta psi];
else
    % three separate arrays
    varargout = {phi, theta, psi};
end
