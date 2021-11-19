function [circle, labels] = regionInscribedCircle(obj, varargin)
% Largest circle inscribed within a region.
%
%   CIRC = regionInscribedCircle(IMG)
%   Computes the maximal circle inscribed in a given region of a binary
%   image, or within each region of label image.
%
%   CIRC = regionInscribedCircle(..., LABELS)
%   Specify the labels for which the inscribed circle needs to be computed.
%   The result is a N-by-3 array with as many rows as the number of labels.
%
%
%   Example
%   % Draw a commplex particle together with its enclosing circle
%     img = fillHoles(Image.read('circles.png'));
%     figure; show(img); hold on;
%     circ = regionInscribedCircle(img);
%     drawCircle(circ, 'LineWidth', 2)
%
%   % Compute and display the equivalent ellipses of several particles
%     img = Image.read('rice.png');
%     img2 = whiteTopHat(img, ones(30, 30));
%     lbl = componentLabeling(img2 > 50, 4);
%     circles = regionInscribedCircle(lbl);
%     figure; show(img); hold on;
%     drawCircle(circles, 'LineWidth', 2, 'Color', 'g');
%
%   See also
%     regionEquivalentEllipse, drawCircle, distanceMap
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-11-18,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE.

%% Process input arguments

if ~ismatrix(obj.Data)
    error('Requires a 2D input image');
end

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


%% Main processing

% allocate memory for result
circle = zeros(nLabels, 3);

for iLabel = 1:nLabels
    % compute distance map
    distMap = distanceMap(obj == labels(iLabel));
    
    % find value and position of the maximum
    maxi = max(distMap(:));    
    [xc, yc] = find(distMap==maxi, 1, 'first');
    
    circle(iLabel,:) = [xc yc maxi];
end

% apply spatial calibration
if isCalibrated(obj)
    circle(:,1:2) = bsxfun(@plus, bsxfun(@times, circle(:,1:2) - 1, obj.Spacing), obj.Origin);
    circle(:,3) = circle(:,3) * obj.Spacing(1);
end
