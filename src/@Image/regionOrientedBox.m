function rect = regionOrientedBox(obj, varargin)
% Minimum-width oriented bounding box of region(s) within image.
%
%   OBB = regionOrientedBox(IMG);
%   Computes the minimum width oriented bounding box of the region(s) in
%   image IMG. IMG is either a binary or a label image. 
%   The result OBB is a N-by-5 array, containing the center, the length,
%   the width, and the orientation of the bounding box of each particle in
%   image. The orientation is given in degrees, in the direction of the
%   largest box axis.
%
%   [OBB, LABELS] = regionOrientedBox(...);
%   Also returns the list of region labels for which the bounding box was
%   computed.
%
%   Example
%   % Compute and display the oriented box of several rice grains
%     img = Image.read('rice.png');
%     img2 = img - opening(img, ones(30, 30));
%     lbl = componentLabeling(img2 > 50, 4);
%     boxes = regionOrientedBox(lbl);
%     show(img); hold on;
%     drawOrientedBox(boxes, 'linewidth', 2, 'color', 'g');
%
%   See also
%     regionFeretDiameter, regionEquivalentEllipse, regionMaxFeretDiameter
 
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

% check if labels are specified
labels = [];
if ~isempty(varargin) && size(varargin{1}, 2) == 1
    labels = varargin{1};
end


%% Initialisations

%% Extract spatial calibration

% extract calibration
spacing = obj.Spacing;
origin  = obj.Origin;
calib   = isCalibrated(obj);

% extract the set of labels, without the background
if isempty(labels)
    labels = findRegionLabels(obj);
end
nLabels = length(labels);

% allocate memory for result
rect = zeros(nLabels, 5);


%% Iterate over labels

for i = 1:nLabels
    % extract points of the current region
    [x, y] = find(obj.Data == labels(i));
    if isempty(x)
        continue;
    end
    
    % transform to physical space if needed
    if calib
        x = (x-1) * spacing(1) + origin(1);
        y = (y-1) * spacing(2) + origin(2);
    end
    
    % special case of regions composed of only one pixel
    if length(x) == 1
        rect(i,:) = [x y 1 1 0];
        continue;
    end

    % compute bounding box of region pixel centers
    try
        obox = orientedBox([x y]);
    catch ME %#ok<NASGU>
        % if points are aligned, convex hull computation fails.
        % Perform manual computation of box.
        xc = mean(x);
        yc = mean(y);
        x = x - xc;
        y = y - yc;
        
        theta = mean(mod(atan2(y, x), pi));
        [x2, y2] = transformPoint(x, y, createRotation(-theta)); %#ok<ASGLU>
        dmin = min(x2);
        dmax = max(x2);
        center = [(dmin + dmax)/2 0];
        center = transformPoint(center, createRotation(theta)) + [xc yc];
        obox  = [center (dmax-dmin) 0 rad2deg(theta)];
    end
    
    % pre-compute trigonometric functions
    thetaMax = obox(5);
    cot = cosd(thetaMax);
    sit = sind(thetaMax);

    % add a thickness of one pixel in both directions
    dsx = spacing(1) * abs(cot) + spacing(2) * abs(sit);
    dsy = spacing(1) * abs(sit) + spacing(2) * abs(cot);
    obox(3:4) = obox(3:4) + [dsx dsy];

    % concatenate rectangle data
    rect(i,:) = obox;
end


function varargout = transformPoint(varargin)
% Apply an affine transform to a point or a point set.
%
%   PT2 = transformPoint(PT1, TRANSFO);
%   Returns the result of the transformation TRANSFO applied to the point
%   PT1. PT1 has the form [xp yp], and TRANSFO is either a 2-by-2, a
%   2-by-3, or a 3-by-3 matrix, 
%
%   Format of TRANSFO can be one of :
%   [a b]   ,   [a b c] , or [a b c]
%   [d e]       [d e f]      [d e f]
%                            [0 0 1]
%
%   PT2 = transformPoint(PT1, TRANSFO);
%   Also works when PTA is a N-by-2 array representing point coordinates.
%   In this case, the result PT2 has the same size as PT1.
%
%   [X2, Y2] = transformPoint(X1, Y1, TRANS);
%   Also works when PX1 and PY1 are two arrays the same size. The function
%   transforms each pair (PX1, PY1), and returns the result in (X2, Y2),
%   which has the same size as (PX1 PY1). 
%
%
%   See also:
%     points2d, transforms2d, translation, rotation
%

% parse input arguments
if length(varargin) == 2
    var = varargin{1};
    px = var(:,1);
    py = var(:,2);
    trans = varargin{2};
elseif length(varargin) == 3
    px = varargin{1};
    py = varargin{2};
    trans = varargin{3};
else
    error('wrong number of arguments in "transformPoint"');
end


% apply linear part of the transform
px2 = px * trans(1,1) + py * trans(1,2);
py2 = px * trans(2,1) + py * trans(2,2);

% add translation vector, if exist
if size(trans, 2) > 2
    px2 = px2 + trans(1,3);
    py2 = py2 + trans(2,3);
end

% format output arguments
if nargout < 2
    varargout{1} = [px2 py2];
elseif nargout
    varargout{1} = px2;
    varargout{2} = py2;
end


function trans = createRotation(varargin)
%CREATEROTATION Create the 3*3 matrix of a rotation.
%
%   TRANS = createRotation(THETA);
%   Returns the rotation corresponding to angle THETA (in radians)
%   The returned matrix has the form :
%   [cos(theta) -sin(theta)  0]
%   [sin(theta)  cos(theta)  0]
%   [0           0           1]
%
%   TRANS = createRotation(POINT, THETA);
%   TRANS = createRotation(X0, Y0, THETA);
%   Also specifies origin of rotation. The result is similar as performing
%   translation(-X0, -Y0), rotation(THETA), and translation(X0, Y0).
%
%   Example
%     % apply a rotation on a polygon
%     poly = [0 0; 30 0;30 10;10 10;10 20;0 20];
%     trans = createRotation([10 20], pi/6);
%     polyT = transformPoint(poly, trans);
%     % display the original and the rotated polygons
%     figure; hold on; axis equal; axis([-10 40 -10 40]);
%     drawPolygon(poly, 'k');
%     drawPolygon(polyT, 'b');
%
%   See also:
%   transforms2d, transformPoint, createRotation90, createTranslation
%

%   ---------
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 06/04/2004.
%

%   HISTORY
%   22/04/2009: rename as createRotation

% default values
cx = 0;
cy = 0;
theta = 0;

% get input values
if length(varargin)==1
    % only angle
    theta = varargin{1};
elseif length(varargin)==2
    % origin point (as array) and angle
    var = varargin{1};
    cx = var(1);
    cy = var(2);
    theta = varargin{2};
elseif length(varargin)==3
    % origin (x and y) and angle
    cx = varargin{1};
    cy = varargin{2};
    theta = varargin{3};
end

% compute coefs
cot = cos(theta);
sit = sin(theta);
tx =  cy*sit - cx*cot + cx;
ty = -cy*cot - cx*sit + cy;

% create transformation matrix
trans = [cot -sit tx; sit cot ty; 0 0 1];
