function res = directionWeights3d13(varargin)
% Direction weights for 13 directions in 3D.
%
%   C = computeDirectionWeights3d13
%   Returns an array of 13-by-1 values, corresponding to directions:
%   C(1)  = [+1  0  0]
%   C(2)  = [ 0 +1  0]
%   C(3)  = [ 0  0 +1]
%   C(4)  = [+1 +1  0]
%   C(5)  = [-1 +1  0]
%   C(6)  = [+1  0 +1]
%   C(7)  = [-1  0 +1]
%   C(8)  = [ 0 +1 +1]
%   C(9)  = [ 0 -1 +1]
%   C(10) = [+1 +1 +1]
%   C(11) = [-1 +1 +1]
%   C(12) = [+1 -1 +1]
%   C(13) = [-1 -1 +1]
%   The sum of the weights in C equals 1.
%   Some values are equal whatever the resolution:
%   C(4)==C(5);
%   C(6)==C(7);
%   C(8)==C(9);
%   C(10)==C(11)==C(12)==C(13);
%
%   C = computeDirectionWeights3d13(DELTA)
%   With DELTA = [DX DY DZ], specifies the resolution of the grid.
%
%   Example
%   c = computeDirectionWeights3d13;
%   sum(c)
%   ans =
%       1.0000
%
%   c = computeDirectionWeights3d13([2.5 2.5 7.5]);
%   sum(c)
%   ans =
%       1.0000
%
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-10-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Initializations

% grid resolution
delta = [1 1 1];
if ~isempty(varargin)
    delta = varargin{1};
end

% If resolution is [1 1 1], return the pre-computed set of weights
if all(delta == [1 1 1])
    area1 = 0.04577789120476 * 2;
    area2 = 0.03698062787608 * 2;
    area3 = 0.03519563978232 * 2;
    res = [...
        area1; area1; area1; ...
        area2; area2; area2; area2; area2; area2;...
        area3; area3; area3; area3 ];
    return;
end

% Define points of interest in the 26 discrete directions
% format is pt[Xpos][Ypos][Zpos], with [X], [Y] or [Z] being one of 
% 'N' (for negative), 'P' (for Positive) or 'Z' (for Zero)

% points below the OXY plane
ptPNN = normalizeVector3d([+1 -1 -1].*delta);
ptPZN = normalizeVector3d([+1  0 -1].*delta);
ptNPN = normalizeVector3d([-1 +1 -1].*delta);
ptZPN = normalizeVector3d([ 0 +1 -1].*delta);
ptPPN = normalizeVector3d([+1 +1 -1].*delta);

% points belonging to the OXY plane
ptPNZ = normalizeVector3d([+1 -1  0].*delta);
ptPZZ = normalizeVector3d([+1  0  0].*delta);
ptNPZ = normalizeVector3d([-1 +1  0].*delta);
ptZPZ = normalizeVector3d([ 0 +1  0].*delta);
ptPPZ = normalizeVector3d([+1 +1  0].*delta);

% points above the OXY plane
ptNNP = normalizeVector3d([-1 -1 +1].*delta);
ptZNP = normalizeVector3d([ 0 -1 +1].*delta);
ptPNP = normalizeVector3d([+1 -1 +1].*delta);
ptNZP = normalizeVector3d([-1  0 +1].*delta);
ptZZP = normalizeVector3d([ 0  0 +1].*delta);
ptPZP = normalizeVector3d([+1  0 +1].*delta);
ptNPP = normalizeVector3d([-1 +1 +1].*delta);
ptZPP = normalizeVector3d([ 0 +1 +1].*delta);
ptPPP = normalizeVector3d([+1 +1 +1].*delta);


%% Spherical cap type 1, direction [1 0 0]

% Compute area of voronoi cell for a point on the Ox axis, i.e. a point
% in the 6-neighborhood of the center.
refPoint = ptPZZ;

% neighbours of chosen point, sorted by CCW angle
neighbors = [ptPNN; ptPNZ; ptPNP; ptPZP; ptPPP; ptPPZ; ptPPN; ptPZN];

% compute area of spherical polygon
area1 = sphericalVoronoiDomainArea(refPoint, neighbors);


%% Spherical cap type 1, direction [0 1 0]

% Compute area of voronoi cell for a point on the Oy axis, i.e. a point
% in the 6-neighborhood of the center.
refPoint    = ptZPZ;

% neighbours of chosen point, sorted by angle
neighbors   = [ptPPZ; ptPPP; ptZPP; ptNPP; ptNPZ; ptNPN; ptZPN; ptPPN];

% compute area of spherical polygon
area2 = sphericalVoronoiDomainArea(refPoint, neighbors);


%% Spherical cap type 1, direction [0 0 1]

% Compute area of voronoi cell for a point on the Oz axis, i.e. a point
% in the 6-neighborhood of the center.
refPoint = ptZZP;

% neighbours of chosen point, sorted by angle
neighbors = [ptPZP; ptPPP; ptZPP; ptNPP; ptNZP; ptNNP; ptZNP; ptPNP];

% compute area of spherical polygon
area3 = sphericalVoronoiDomainArea(refPoint, neighbors);


%% Spherical cap type 2, direction [1 1 0]

% Compute area of voronoi cell for a point on the Oxy plane, i.e. a point
% in the 18-neighborhood
refPoint = ptPPZ;

% neighbours of chosen point, sorted by angle
neighbors = [ptPZZ; ptPPP; ptZPZ; ptPPN];

% compute area of spherical polygon
area4 = sphericalVoronoiDomainArea(refPoint, neighbors);


%% Spherical cap type 2, direction [1 0 1]

% Compute area of voronoi cell for a point on the Oxz plane, i.e. a point
% in the 18-neighborhood
refPoint = ptPZP;
% neighbours of chosen point, sorted by angle
neighbors = [ptPZZ; ptPPP; ptZZP; ptPNP];

% compute area of spherical polygon
area5 = sphericalVoronoiDomainArea(refPoint, neighbors);


%% Spherical cap type 2, direction [0 1 1]

% Compute area of voronoi cell for a point on the Oxy plane, i.e. a point
% in the 18-neighborhood
refPoint = ptZPP;
% neighbours of chosen point, sorted by angle
neighbors = [ptZPZ; ptNPP; ptZZP; ptPPP];

% compute area of spherical polygon
area6 = sphericalVoronoiDomainArea(refPoint, neighbors);


%% Spherical cap type 3 (all cubic diagonals)

% Compute area of voronoi cell for a point on the Oxyz diagonal, i.e. a
% point in the 26 neighborhood only
refPoint = ptPPP;
% neighbours of chosen point, sorted by angle
neighbors = [ptPZP; ptZZP; ptZPP; ptZPZ; ptPPZ; ptPZZ];

% compute area of spherical polygon
area7 = sphericalVoronoiDomainArea(refPoint, neighbors);


%% Concatenate results

% return computed areas, normalized by the area of the unit sphere surface
res = [...
    area1 area2 area3 ...
    area4 area4 area5 area5 area6 area6...
    area7 area7 area7 area7...
    ] / (2 * pi);

function area = sphericalVoronoiDomainArea(refPoint, neighbors)
% Compute area of a spherical voronoi domain
%
%   AREA = sphericalVoronoiDomainArea(GERM, NEIGHBORS)
%   GERM is a 1-by-3 row vector representing cartesian coordinates of a
%   point on the sphere (in X, Y Z order)
%   NEIGHBORS is a N-by-3 array representing cartesian coordinates of the
%   germ neighbors. It is expected that NEIGHBORS contains only neighbors
%   that effectively contribute to the voronoi domain.
%

% reference sphere
sphere = [0 0 0 1];

% number of neigbors, and number of sides of the domain
nbSides = size(neighbors, 1);

% compute planes containing separating circles
planes = zeros(nbSides, 9);
for i = 1:nbSides
    planes(i,1:9) = normalizePlane(medianPlane(refPoint, neighbors(i,:)));
end

% allocate memory
lines       = zeros(nbSides, 6);
intersects  = zeros(2*nbSides, 3);

% compute circle-circle intersections
for i=1:nbSides
    lines(i,1:6) = intersectPlanes(planes(i,:), ...
        planes(mod(i,nbSides)+1,:));
    intersects(2*i-1:2*i,1:3) = intersectLineSphere(lines(i,:), sphere);
end

% keep only points in the same direction than refPoint
ind = dot(intersects, repmat(refPoint, [2*nbSides 1]), 2)>0;
intersects = intersects(ind,:);
nbSides = size(intersects, 1);

% compute spherical area of each triangle [center  pt[i+1]%4   pt[i] ]
angles = zeros(nbSides, 1);
for i=1:nbSides
    pt1 = intersects(i, :);
    pt2 = intersects(mod(i  , nbSides)+1, :);
    pt3 = intersects(mod(i+1, nbSides)+1, :);
    
    angles(i) = sphericalAngle(pt1, pt2, pt3);
    angles(i) = min(angles(i), 2*pi-angles(i));
end

% compute area of spherical polygon
area = sum(angles) - pi*(nbSides-2);


function plane = medianPlane(p1, p2)
% Create a plane in the middle of 2 points.

% unify data dimension
if size(p1, 1) == 1
    p1 = repmat(p1, [size(p2, 1) 1]);
elseif size(p2, 1) == 1
    p2 = repmat(p2, [size(p1, 1) 1]);
elseif size(p1, 1) ~= size(p2, 1)    
    error('data should have same length, or one data should have length 1');
end

% middle point
p0  = (p1 + p2)/2;

% normal to plane
n   = p2 - p1;

% create plane from point and normal
plane = createPlane(p0, n);


function line = intersectPlanes(plane1, plane2, varargin)
% Return intersection line between 2 planes in space.

tol = 1e-14;
if ~isempty(varargin)
    tol = varargin{1};
end

% plane normal
n1 = normalizeVector3d(cross(plane1(:,4:6), plane1(:, 7:9), 2));
n2 = normalizeVector3d(cross(plane2(:,4:6), plane2(:, 7:9), 2));

% test if planes are parallel
if abs(cross(n1, n2, 2)) < tol
    line = [NaN NaN NaN NaN NaN NaN];
    return;
end

% Uses Hessian form, ie : N.p = d
% I this case, d can be found as : -N.p0, when N is normalized
d1 = dot(n1, plane1(:,1:3), 2);
d2 = dot(n2, plane2(:,1:3), 2);

% compute dot products
dot1 = dot(n1, n1, 2);
dot2 = dot(n2, n2, 2);
dot12 = dot(n1, n2, 2);

% intermediate computations
det = dot1*dot2 - dot12*dot12;
c1  = (d1*dot2 - d2*dot12)./det;
c2  = (d2*dot1 - d1*dot12)./det;

% compute line origin and direction
p0  = c1*n1 + c2*n2;
dp  = cross(n1, n2, 2);

line = [p0 dp];


function plane = createPlane(p0, n)
% Create a plane in parametrized form
% P = createPlane(P0, N);

% normal is given by a 3D vector
n = normalizeVector3d(n);

% ensure same dimension for parameters
if size(p0, 1) == 1
    p0 = repmat(p0, [size(n, 1) 1]);
end
if size(n, 1) == 1
    n = repmat(n, [size(p0, 1) 1]);
end

% find a vector not colinear to the normal
v0 = repmat([1 0 0], [size(p0, 1) 1]);
inds = vectorNorm3d(cross(n, v0, 2))<1e-14;
v0(inds, :) = repmat([0 1 0], [sum(inds) 1]);

% create direction vectors
v1 = normalizeVector3d(cross(n, v0, 2));
v2 = -normalizeVector3d(cross(v1, n, 2));

% concatenate result in the array representing the plane
plane = [p0 v1 v2];
    

function plane2 = normalizePlane(plane1)
% Normalize parametric representation of a plane

% compute first direction vector
d1  = normalizeVector3d(plane1(:,4:6));

% compute second direction vector
n   = normalizeVector3d(planeNormal(plane1));
d2  = -normalizeVector3d(crossProduct3d(d1, n));

% compute origin point of the plane
origins = repmat([0 0 0], [size(plane1, 1) 1]);
p0 = projPointOnPlane(origins, [plane1(:,1:3) d1 d2]);

% create the resulting plane
plane2 = [p0 d1 d2];


function n = planeNormal(plane)
% Compute the normal to a plane

% plane normal
outSz = size(plane);
outSz(2) = 3;
n = zeros(outSz);
n(:) = crossProduct3d(plane(:,4:6,:), plane(:, 7:9,:));

function alpha = sphericalAngle(p1, p2, p3)
% Compute angle between points on the sphere

% test if points are given as matlab spherical coordinates
if size(p1, 2) == 2
    [x, y, z] = sph2cart(p1(:,1), p1(:,2), ones(size(p1,1), 1));
    p1 = [x y z];
    [x, y, z] = sph2cart(p2(:,1), p2(:,2), ones(size(p2,1), 1));
    p2 = [x y z];
    [x, y, z] = sph2cart(p3(:,1), p3(:,2), ones(size(p3,1), 1));
    p3 = [x y z];
end

% normalize points
p1  = normalizeVector3d(p1);
p2  = normalizeVector3d(p2);
p3  = normalizeVector3d(p3);

% create the plane tangent to the unit sphere and containing central point
plane = createPlane(p2, p2);

% project the two other points on the plane
pp1 = planePosition(projPointOnPlane(p1, plane), plane);
pp3 = planePosition(projPointOnPlane(p3, plane), plane);

% compute angle on the tangent plane
pp2 = zeros(max(size(pp1, 1), size(pp3,1)), 2);
alpha = angle3Points(pp1, pp2, pp3);


function pos = planePosition(point, plane)
% Compute position of a point on a plane

% size of input arguments
npl = size(plane, 1);
npt = size(point, 1);

% check inputs have compatible sizes
if npl ~= npt && npl > 1 && npt > 1
    error('geom3d:planePoint:inputSize', ...
        'plane and point should have same size, or one of them must have 1 row');
end

% origin and direction vectors of the plane
p0 = plane(:, 1:3);
d1 = plane(:, 4:6);
d2 = plane(:, 7:9);

% Compute dot products with direction vectors of the plane
if npl > 1 || npt == 1
    s = dot(bsxfun(@minus, point, p0), d1, 2) ./ vectorNorm3d(d1);
    t = dot(bsxfun(@minus, point, p0), d2, 2) ./ vectorNorm3d(d2);
else
    % we have npl == 1 and npt > 1
    d1 = d1 / vectorNorm3d(d1);
    d2 = d2 / vectorNorm3d(d2);
    inds = ones(npt,1);
    s = dot(bsxfun(@minus, point, p0), d1(inds, :), 2);
    t = dot(bsxfun(@minus, point, p0), d2(inds, :), 2);
end

% % old version:
% s = dot(point-p0, d1, 2) ./ vectorNorm3d(d1);
% t = dot(point-p0, d2, 2) ./ vectorNorm3d(d2);

pos = [s t];


function point = projPointOnPlane(point, plane)
% Return the orthogonal projection of a point on a plane

% Unpack the planes into origins and normals, keeping original shape
plSize = size(plane);
plSize(2) = 3;
[origins, normals] = deal(zeros(plSize));
origins(:) = plane(:,1:3,:);
normals(:) = crossProduct3d(plane(:,4:6,:), plane(:, 7:9,:));

% difference between origins of plane and point
dp = bsxfun(@minus, origins, point);

% relative position of point on normal's line
t = bsxfun(@rdivide, sum(bsxfun(@times,normals,dp),2), sum(normals.^2,2));

% add relative difference to project point back to plane
point = bsxfun(@plus, point, bsxfun(@times, t, normals));


function points = intersectLineSphere(line, sphere, varargin)
%INTERSECTLINESPHERE Return intersection points between a line and a sphere

% check if user-defined tolerance is given
tol = 1e-14;
if ~isempty(varargin)
    tol = varargin{1};
end

% difference between centers
dc = bsxfun(@minus, line(:, 1:3), sphere(:, 1:3));

% equation coefficients
a = sum(line(:, 4:6) .* line(:, 4:6), 2);
b = 2 * sum(bsxfun(@times, dc, line(:, 4:6)), 2);
c = sum(dc.*dc, 2) - sphere(:,4).*sphere(:,4);

% solve equation
delta = b.*b - 4*a.*c;

% initialize empty results
points = NaN * ones(2 * size(delta, 1), 3);

% process couples with two intersection points
inds = find(delta > tol);
if ~isempty(inds)
    % delta positive: find two roots of second order equation
    u1 = (-b(inds) -sqrt(delta(inds))) / 2 ./ a(inds);
    u2 = (-b(inds) +sqrt(delta(inds))) / 2 ./ a(inds);
    
    % convert into 3D coordinate
    points(inds, :) = line(inds, 1:3) + bsxfun(@times, u1, line(inds, 4:6));
    points(inds+length(delta),:) = line(inds, 1:3) + bsxfun(@times, u2, line(inds, 4:6));
end


function theta = angle3Points(p1, p2, p3)
% Compute oriented angle made by 3 points
theta = lineAngle(createLine(p2, p1), createLine(p2, p3));


function line = createLine(p1, p2)
% Create a line from two points on the line.
line = [p1(:,1), p1(:,2), p2(:,1)-p1(:,1), p2(:,2)-p1(:,2)];    


function theta = lineAngle(varargin)
% Computes angle between two straight lines

if nargin == 1
    % angle of one line with horizontal
    line = varargin{1};
    theta = mod(atan2(line(:,4), line(:,3)) + 2*pi, 2*pi);
    
elseif nargin == 2
    % angle between two lines
    theta1 = lineAngle(varargin{1});
    theta2 = lineAngle(varargin{2});
    theta = mod(bsxfun(@minus, theta2, theta1)+2*pi, 2*pi);
end


function c = crossProduct3d(a,b)
% Vector cross product faster than inbuilt MATLAB cross.

% size of inputs
sizeA = size(a);
sizeB = size(b);

% Initialise c to the size of a or b, whichever has more dimensions. If
% they have the same dimensions, initialise to the larger of the two
switch sign(numel(sizeA) - numel(sizeB))
    case 1
        c = zeros(sizeA);
    case -1
        c = zeros(sizeB);
    otherwise
        c = zeros(max(sizeA, sizeB));
end

c(:) = bsxfun(@times, a(:,[2 3 1],:), b(:,[3 1 2],:)) - ...
       bsxfun(@times, b(:,[2 3 1],:), a(:,[3 1 2],:));


function vn = normalizeVector3d(v)
% Normalize a 3D vector to have norm equal to 1
vn   = bsxfun(@rdivide, v, sqrt(sum(v.^2, 2)));

function n = vectorNorm3d(v)
% Norm of a 3D vector or of set of 3D vectors
n = sqrt(sum(v.*v, 2));
