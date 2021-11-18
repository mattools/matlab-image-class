function [gd, labels] = regionGeodesicDiameter(obj, varargin)
% Compute geodesic diameter of regions within a label imag.
%
%   GD = regionGeodesicDiameter(IMG)
%   where IMG is a label image, returns the geodesic diameter of each
%   particle in the image. If IMG is a binary image, a connected-components
%   labelling is performed first. 
%   GD is a column vector containing the geodesic diameter of each particle.
%
%   GD = regionGeodesicDiameter(IMG, WS)
%   Specifies the weights associated to neighbor pixels. WS(1) is the
%   distance to orthogonal pixels, and WS(2) is the distance to diagonal
%   pixels. An optional WS(3) weight may be specified, corresponding to
%   chess-knight moves. Default is [5 7 11], recommended for 5-by-5 masks.
%   The final length is normalized by weight for orthogonal pixels. For
%   thin structures (skeletonization result), or for very close particles,
%   the [3 4] weights recommended by Borgeors may be more appropriate.
%   
%   GD = regionGeodesicDiameter(..., 'verbose', true);
%   Display some informations about the computation procedure, that may
%   take some time for large and/or complicated images.
%
%   [GD, LABELS] = regionGeodesicDiameter(...);
%   Also returns the list of labels for which the geodesic diameter was
%   computed.
%
%
%   These algorithm uses 3 steps:
%   * first propagate distance from region boundary to find a pixel
%       approximately in the center of the particle(s)
%   * propagate distances from the center, and keep the furthest pixel,
%       which is assumed to be a geodesic extremity
%   * propagate distances from the geodesic extremity, and keep the maximal
%       distance.
%   This algorithm is less time-consuming than the direct approach that
%   consists in computing geodesic propagation and keeping the max value.
%   However, for some cases (e.g. particles with holes) in can happen that
%   the two methods give different results.
%
%
%   Notes: 
%   * only planar images are currently supported.
%   * the particles are assumed to be 8 connected. If two or more particles
%       touch by a corner, the result will not be valid.
%
%   
%   Example
%     % segment and labelize image of grains, and compute their geodesic
%     % diameter
%     img = Image.read('rice.png');
%     img2 = whiteTopHat(img, ones(30, 30));
%     bin = opening(img2 > 50, ones(3, 3));
%     lbl = componentLabeling(bin);
%     gd = regionGeodesicDiameter(lbl);
%     plot(gd, '+');
%
%   References
%   * Lantuejoul, C. and Beucher, S. (1981): "On the use of geodesic metric
%       in image analysis", J. Microsc., 121(1), pp. 39-49.
%       http://dx.doi.org/10.1111/j.1365-2818.1981.tb01197.x
%   * Coster & Chermant: "Precis d'analyse d'images", Ed. CNRS 1989.
%
%   See also
%     regionMaxFeretDiameter, geodesicDistanceMap, chamferDistanceMap
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-11-18,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE.


%% Default values 

% weights for propagating geodesic distances
ws = [5 7 11];

% no verbosity by default
verbose = 0;

labels = [];


%% Process input arguments

% extract weights if present
if ~isempty(varargin)
    if isnumeric(varargin{1})
        ws = varargin{1};
        varargin(1) = [];
    end
end

% Extract options
while ~isempty(varargin)
    paramName = varargin{1};
    if strcmpi(paramName, 'verbose')
        verbose = varargin{2};
    elseif strcmpi(paramName, 'labels')
        labels = varargin{2};
    else
        error(['Unkown option in regionGeodesicDiameter: ' paramName]);
    end
    varargin(1:2) = [];
end

% make input image a label image if this is not the case
if isBinaryImage(obj)
    labels = 1;
end

% extract the set of labels, without the background
if isempty(labels)
    labels = findRegionLabels(obj);
end
nLabels = length(labels);
  

%% Detection of center point (furthest point from boundary)

if verbose
    disp(sprintf('Computing geodesic diameters of %d region(s).', nLabels)); %#ok<*DSPS>
end

if verbose
    disp('Computing initial centers...'); 
end

% computation of distance map from empirical markers
dist = chamferDistanceMap(obj, ws, 'normalize', false, 'verbose', verbose);


%% Second pass: find a geodesic extremity

if verbose
    disp('Create marker image of initial centers'); 
end

% Create arrays to find the pixel with largest distance in each label
maxVals = -ones(nLabels, 1);
maxValInds = zeros(nLabels, 1);

% iterate over pixels, and compare current distance with max distance
% stored for corresponding label
for i = 1:numel(obj.Data)
    label = obj.Data(i);

    if label > 0
        ind = find(labels == label);
        if dist.Data(i) > maxVals(ind)
            maxVals(ind) = dist.Data(i);
            maxValInds(ind) = i;
        end
    end
end

% compute new seed point in each label, and use it as new marker
markers = Image.false(size(obj));
markers.Data(maxValInds) = 1;

if verbose
    disp('Propagate distance from initial centers'); 
end

% recomputes geodesic distance from new markers
dist = geodesicDistanceMap(markers, obj, ws, 'normalize', false, 'verbose', verbose);


%% third pass: find second geodesic extremity

if verbose
    disp('Create marker image of first geodesic extremity'); 
end

% reset arrays to find the pixel with largest distance in each label
maxVals = -ones(nLabels, 1);
maxValInds = zeros(nLabels, 1);

% iterate over pixels to identify second geodesic extremities
for i = 1:numel(obj.Data)
    label = obj.Data(i);
    if label > 0
        ind = find(labels == label);
        if dist.Data(i) > maxVals(ind)
            maxVals(ind) = dist.Data(i);
            maxValInds(ind) = i;
        end
    end
end

% compute new seed point in each label, and use it as new marker
markers = Image.false(size(obj));
markers.Data(maxValInds) = 1;

if verbose
    disp('Propagate distance from first geodesic extremity'); 
end

% recomputes geodesic distance from new markers
dist = geodesicDistanceMap(markers, obj, ws, 'normalize', false, 'verbose', verbose);


%% Final computation of geodesic distances

if verbose
    disp('Compute geodesic diameters'); 
end

% keep max geodesic distance inside each label
if isinteger(ws)
    gd = zeros(nLabels, 1, class(ws));
else
    gd = -ones(nLabels, 1, class(ws));
end

for i = 1:numel(obj.Data)
    label = obj.Data(i);
    if label > 0
        ind = find(labels == label);
        if dist.Data(i) > gd(ind)
            gd(ind) = dist.Data(i);
        end
    end
end

% normalize by first weight, and add 1 for taking into account pixel
% thickness 
gd = gd / ws(1) + 1;

% finally, normalize with spatial calibration of image
gd = gd * obj.Spacing(1);
