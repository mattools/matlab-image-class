function test_suite = testLinearInterpolator2D(varargin)
% Test function for class LinearInterpolator2D
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

function testCreateInterpolator

dim = [15 10];
REF = 200;

% create test image
dat = zeros([dim(2) dim(1)], 'uint8');
dat(3:end-3, 5:end-5) = REF;
img = Image2D(dat);

% create interpolator
interp = LinearInterpolator2D(img);
assertTrue(interp.isvalid);

% copy constructor
interp2 = LinearInterpolator2D(interp);
assertTrue(interp2.isvalid);

delete(interp);
assertTrue(interp2.isvalid);

function testEvaluateSingleCoord

REF = 200;
% evaluate for a single point
interp = createInterpolator();
x = 8; y = 5;
val = interp.evaluate(x, y);
assertAlmostEqual(REF, val);

function testEvaluateSinglePoint

REF = 200;
interp = createInterpolator();
x = 8; y = 5;
point = [x y];
val = interp.evaluate(point);
assertAlmostEqual(REF, val);

function testEvaluateCoordArray

lx = [6 7 8 9];
ly = [4 5];
[x y] = meshgrid(lx, ly);

interp = createInterpolator();
val = interp.evaluate(x, y);
assertElementsAlmostEqual(size(x), size(val));

[val inside] = interp.evaluate(x, y);
assertElementsAlmostEqual(size(x), size(val));
assertElementsAlmostEqual(size(x), size(inside));

function testEvaluatePointArray

lx = [6 7 8 9];
ly = [4 5];
[x y] = meshgrid(lx, ly);
points = [x(:) y(:)];
n = size(points, 1);

interp = createInterpolator();
[val inside] = interp.evaluate(points);

assertElementsAlmostEqual(n, length(val));
assertElementsAlmostEqual(n, length(inside));


function testIsAnImageInterpolator

interp = createInterpolator();
assertTrue(isa(interp, 'ImageInterpolator2D'));

%% Utilitary functions

function interp = createInterpolator
dim = [15 10];
REF = 200;

% create test image
dat = zeros([dim(2) dim(1)], 'uint8');
dat(3:end-3, 5:end-5) = REF;
img = Image2D(dat);

% create interpolator
interp = LinearInterpolator2D(img);



