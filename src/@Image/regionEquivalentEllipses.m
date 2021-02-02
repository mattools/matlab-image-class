function [ellipse, labels] = regionEquivalentEllipses(obj, varargin)
% Equivalent ellipse of region(s) in a binary or label image.
%
%   ELLI = regionEquivalentEllipses(IMG)
%   Computes the ellipse with same second order moments for each region in
%   label image IMG. If the case of a binary image, a single ellipse
%   corresponding to the foreground (i.e. to the region with pixel value 1)
%   will be computed. 
%
%   The result is a N-by-5 array ELLI = [XC YC A B THETA], containing
%   coordinates of ellipse center, lengths of major and minor semi-axes,
%   and the orientation of the largest axis (in degrees, and
%   counter-clockwise). 
%
%   ELLI = regionEquivalentEllipses(..., LABELS)
%   Specifies the labels for which the equivalent ellipse needs to be
%   computed. The result is a N-by-5 array with as many rows as the number
%   of labels. 
%
%
%   Example
%   % Draw a commplex particle together with its equivalent ellipse
%     img = Image.read('circles.png');
%     show(img); hold on;
%     elli = regionEquivalentEllipses(img);
%     drawEllipse(elli)
%
%   % Compute and display the equivalent ellipses of several particles
%     img = Image.read('rice.png');
%     img2 = img - opening(img, ones(30, 30));
%     lbl = componentLabeling(img2 > 50, 4);
%     ellipses = regionEquivalentEllipses(lbl);
%     show(img); hold on;
%     drawEllipse(ellipses, 'linewidth', 2, 'color', 'g');
%
%   See also
%     regionCentroids, regionBoxes
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-02-02,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE.


%% extract spatial calibration

% extract calibration
spacing = obj.Spacing;
origin  = obj.Origin;
calib   = isCalibrated(obj);


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
nLabels = length(labels);

% allocate memory for result
ellipse = zeros(nLabels, 5);


%% Extract ellipse corresponding to each label

for i = 1:nLabels
    % extract points of the current particle
    [x, y] = find(obj.Data==labels(i));
    
    % transform to physical space if needed
    if calib
        x = (x-1) * spacing(1) + origin(1);
        y = (y-1) * spacing(2) + origin(2);
    end
    
    % compute centroid, used as center of equivalent ellipse
    xc = mean(x);
    yc = mean(y);
    
    % recenter points (should be better for numerical accuracy)
    x = x - xc;
    y = y - yc;

    % number of points
    n = length(x);
    
    % compute second order parameters. 1/12 is the contribution of a single
    % pixel, then for regions with only one pixel the resulting ellipse has
    % positive radii.
    Ixx = sum(x.^2) / n + spacing(1)^2/12;
    Iyy = sum(y.^2) / n + spacing(2)^2/12;
    Ixy = sum(x.*y) / n;
    
    % compute semi-axis lengths of ellipse
    common = sqrt( (Ixx - Iyy)^2 + 4 * Ixy^2);
    ra = sqrt(2) * sqrt(Ixx + Iyy + common);
    rb = sqrt(2) * sqrt(Ixx + Iyy - common);
    
    % compute ellipse angle and convert into degrees
    theta = atan2(2 * Ixy, Ixx - Iyy) / 2;
    theta = theta * 180 / pi;
    
    % create the resulting equivalent ellipse
    ellipse(i,:) = [xc yc ra rb theta];
end
