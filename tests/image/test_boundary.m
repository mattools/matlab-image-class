function tests = test_boundary(varargin)
%TEST_BOUNDARY  One-line description here, please.
%
%   output = test_boundary(input)
%
%   Example
%   test_boundary
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_basic(testCase) %#ok<*DEFNU>

img = Image.read('circles.png');

bnd = boundary(img);

assertTrue(testCase, isa(bnd, 'Image'));
assertEqual(testCase, size(img), size(bnd));

function test_rect(testCase)

img = Image.read('circles.png');
img = crop(img, [1 200 1 255]);

bnd = boundary(img);

assertTrue(testCase, isa(bnd, 'Image'));
assertEqual(testCase, size(img), size(bnd));

function test_Inner(testCase)

img = Image.read('circles.png');

bnd = boundary(img, 'inner');

assertTrue(testCase, isa(bnd, 'Image'));
assertEqual(testCase, size(img), size(bnd));

function test_Outer(testCase)

img = Image.read('circles.png');

bnd = boundary(img, 'outer');

assertTrue(testCase, isa(bnd, 'Image'));
assertEqual(testCase, size(img), size(bnd));


function test_Conn8(testCase)

img = Image.read('circles.png');

bnd = boundary(img, 8);

assertTrue(testCase, isa(bnd, 'Image'));
assertEqual(testCase, size(img), size(bnd));


function test_basic_3d(testCase)

img = Image.create(false([5 5 5]));
img(2:4, 2:4, 2:4) = true;

bnd = boundary(img);

assertTrue(testCase, isa(bnd, 'Image'));
assertEqual(testCase, size(img), size(bnd));

exp = Image.create(false([5 5 5]));
exp(2:4, 2:4, 2:4) = true;
exp(3, 3, 3) = false;
assertEqual(testCase, 0, sum(exp ~= bnd));


function test_inner_3d(testCase)

img = Image.create(false([5 5 5]));
img(2:4, 2:4, 2:4) = true;

bnd = boundary(img, 'inner');

assertTrue(testCase, isa(bnd, 'Image'));
assertEqual(testCase, size(img), size(bnd));

exp = Image.create(false([5 5 5]));
exp(2:4, 2:4, 2:4) = true;
exp(3, 3, 3) = false;
assertEqual(testCase, 0, sum(exp ~= bnd));


function test_outer_3d(testCase)

img = Image.create(false([5 5 5]));
img(2:4, 2:4, 2:4) = true;

bnd = boundary(img, 'outer');

assertTrue(testCase, isa(bnd, 'Image'));
assertEqual(testCase, size(img), size(bnd));


function test_outer_conn26_3d(testCase)

img = Image.create(false([5 5 5]));
img(2:4, 2:4, 2:4) = true;

bnd = boundary(img, 26, 'outer');

assertTrue(testCase, isa(bnd, 'Image'));
assertEqual(testCase, size(img), size(bnd));

exp = Image.create(true([5 5 5]));
exp(2:4, 2:4, 2:4) = false;
assertEqual(testCase, 0, sum(exp ~= bnd));


function test_conn26_3d(testCase)

img = Image.create(false([5 5 5]));
img(2:4, 2:4, 2:4) = true;

bnd = boundary(img, 26);

assertTrue(testCase, isa(bnd, 'Image'));
assertEqual(testCase, size(img), size(bnd));

