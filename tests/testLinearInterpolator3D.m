function test_suite = testLinearInterpolator3D(varargin) %#ok<STOUT>
% Test function for class LinearInterpolator3D
%   output = testImArea(input)
%
%   Example
%   testImEuler2d
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-04-22,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.
% Licensed under the terms of the LGPL, see the file "license.txt"

initTestSuite;

function testCreateInterpolator %#ok<*DEFNU>

dim = [15 12 10];
REF = 200;

% create test image
dat = zeros([dim(2) dim(1) dim(3)], 'uint8');
dat(3:end-3, 5:end-5, 3:end-3) = REF;
img = Image.create(dat);

% create interpolator
interp = LinearInterpolator3D(img);
assertTrue(interp.isvalid);

% copy constructor
interp2 = LinearInterpolator3D(interp);
assertTrue(interp2.isvalid);

delete(interp);
assertTrue(interp2.isvalid);

function testEvaluateSingleCoord

REF = 200;
% evaluate for a single point
interp = createInterpolator();
x = 8; y = 5; z = 6;
val = interp.evaluate(x, y, z);
assertAlmostEqual(REF, val);

function testEvaluateSinglePoint

REF = 200;
interp = createInterpolator();
x = 8; y = 5; z = 6;
point = [x y z];
val = interp.evaluate(point);
assertAlmostEqual(REF, val);

function testEvaluateCoordArray

lx = [6 7 8 9];
ly = [4 5];
lz = [4 5 6];
[x y z] = meshgrid(lx, ly, lz);

interp = createInterpolator();
val = interp.evaluate(x, y, z);
assertElementsAlmostEqual(size(x), size(val));

[val inside] = interp.evaluate(x, y, z);
assertElementsAlmostEqual(size(x), size(val));
assertElementsAlmostEqual(size(x), size(inside));

function testEvaluatePointArray

lx = [6 7 8 9];
ly = [4 5];
lz = [4 5 6];
[x y z] = meshgrid(lx, ly, lz);
points = [x(:) y(:) z(:)];
n = size(points, 1);

interp = createInterpolator();
[val inside] = interp.evaluate(points);

assertElementsAlmostEqual(n, length(val));
assertElementsAlmostEqual(n, length(inside));


function testIsAnImageInterpolator3D

interp = createInterpolator();
assertTrue(isa(interp, 'ImageInterpolator3D'));

%% Utilitary functions

function interp = createInterpolator
dim = [15 12 10];
REF = 200;

% create test image
dat = zeros([dim(2) dim(1) dim(3)], 'uint8');
dat(3:end-3, 5:end-5, 3:end-3) = REF;
img = Image.create(dat);

% create interpolator
interp = LinearInterpolator3D(img);



