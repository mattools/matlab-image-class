function [diam, thetaMax] = regionMaxFeretDiameter(obj, varargin)
% Maximum Feret diameter of regions within a binary or label image.
%
%   FD = regionMaxFeretDiameter(IMG)
%   Computes the maximum Feret diameter of particles in label image IMG.
%   The result is a N-by-1 column vector, containing the Feret diameter of
%   each particle in IMG.
%
%   [FD, THETAMAX] = regionMaxFeretDiameter(IMG)
%   Also returns the direction for which the diameter is maximal. THETAMAX
%   is given in degrees, between 0 and 180.
%
%   FD = regionMaxFeretDiameter(IMG, LABELS)
%   Specify the labels for which the Feret diameter needs to be computed.
%   The result is a N-by-1 array with as many rows as the number of labels.
%
%
%   Example
%     img = Image.read('circles.png');
%     diam = regionMaxFeretDiameter(img)
%     diam =
%         272.7144
%
%   See also
%     regionFeretDiameter, regionOrientedBox
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-10-18,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE.


%% Process input arguments

if ndims(obj) ~= 2 %#ok<ISMAT>
    error('Requires 2D image as input');
end

% extract orientations
thetas = 180;
if ~isempty(varargin) && size(varargin{1}, 2) == 1
    thetas = varargin{1};
    varargin(1) = [];
end

if isscalar(thetas)
    % assume this is the number of directions to use
    thetas = linspace(0, 180, thetas+1);
    thetas = thetas(1:end-1);
end

% check if labels are specified
labels = [];
if ~isempty(varargin) && size(varargin{1}, 2) == 1
    labels = varargin{1};
end


%% Initialisations

% extract the set of labels, without the background
if isempty(labels)
    labels = findRegionLabels(obj);
end
nLabels = length(labels);

% allocate memory for result
diam = zeros(nLabels, 1);
thetaMax = zeros(nLabels, 1);


%% Main processing 

% for each region, compute set of diameters, and keep the max
for i = 1:nLabels
    % compute Feret Diameters of current region
    diams = regionFeretDiameter(obj == labels(i), thetas);
    
    % find max diameter, with indices
    [diam(i), ind] = max(diams, [], 2);
    
    % keep max orientation
    thetaMax(i) = thetas(ind);
end
