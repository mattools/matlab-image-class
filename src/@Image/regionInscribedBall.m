function [ball, labels] = regionInscribedBall(obj, varargin)
% Largest ball inscribed within a region.
%
%   BALL = regionInscribedBall(IMG)
%   Computes the maximal ball inscribed in a given region of a 3D binary
%   image, or within each region of 3D label image.
%
%   BALL = regionInscribedBall(..., LABELS)
%   Specify the labels for which the inscribed balls needs to be computed.
%   The result is a N-by-3 array with as many rows as the number of labels.
%
%   Example
%     img = Image.false([12 12 12]);
%     img(2:10, 2:10, 2:10) = 1;
%     ball = regionInscribedBall(img)
%     ball =
%          6     6     6     5
%
%   See also
%     regionEquivalentEllipsoid, drawSphere, distanceMap,
%     regionInscribedCircle
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-11-18,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE.


%% Process input arguments

if ndims(obj.Data) ~= 3
    error('Requires a 3D input image');
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

% allocate memory for result (3 coords + 1 radius)
ball = zeros(nLabels, 4);

for iLabel = 1:nLabels
    % compute distance map
    distMap = distanceMap(obj == labels(iLabel));
    
    % find value and position of the maximum
    [maxi, inds] = max(distMap.Data(:));
    [yb, xb, zb] = ind2sub(size(distMap), inds);
    
    ball(iLabel,:) = [xb yb zb maxi];
end

% apply spatial calibration
if isCalibrated(obj)
    ball(:,1:3) = bsxfun(@plus, bsxfun(@times, ball(:,1:3) - 1, obj.Spacing), obj.Origin);
    ball(:,4) = ball(:,4) * obj.Spacing(1);
end
