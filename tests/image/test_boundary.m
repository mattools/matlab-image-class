function test_suite = test_boundary(varargin) %#ok<STOUT>
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

initTestSuite;

function test_basic %#ok<*DEFNU>

img = Image.read('circles.png');
bnd = boundary(img);
assertTrue(isa(bnd, 'Image'));
assertEqual(size(img), size(bnd));

function test_rect

img = Image.read('circles.png');
img = crop(img, [1 200 1 255]);
bnd = boundary(img);
assertTrue(isa(bnd, 'Image'));
assertEqual(size(img), size(bnd));

function test_Inner

img = Image.read('circles.png');
bnd = boundary(img, 'inner');
assertTrue(isa(bnd, 'Image'));
assertEqual(size(img), size(bnd));

function test_Outer

img = Image.read('circles.png');
bnd = boundary(img, 'outer');
assertTrue(isa(bnd, 'Image'));
assertEqual(size(img), size(bnd));


function test_Conn8

img = Image.read('circles.png');
bnd = boundary(img, 8);
assertTrue(isa(bnd, 'Image'));
assertEqual(size(img), size(bnd));

function test_basic_3d

img = Image.create(false([5 5 5]));
img(2:4, 2:4, 2:4) = true;

bnd = boundary(img);

assertTrue(isa(bnd, 'Image'));
assertEqual(size(img), size(bnd));

exp = Image.create(false([5 5 5]));
exp(2:4, 2:4, 2:4) = true;
exp(3, 3, 3) = false;
assertEqual(0, sum(exp ~= bnd));


function test_inner_3d

img = Image.create(false([5 5 5]));
img(2:4, 2:4, 2:4) = true;

bnd = boundary(img, 'inner');

assertTrue(isa(bnd, 'Image'));
assertEqual(size(img), size(bnd));

exp = Image.create(false([5 5 5]));
exp(2:4, 2:4, 2:4) = true;
exp(3, 3, 3) = false;
assertEqual(0, sum(exp ~= bnd));


function test_outer_3d

img = Image.create(false([5 5 5]));
img(2:4, 2:4, 2:4) = true;

bnd = boundary(img, 'outer');

assertTrue(isa(bnd, 'Image'));
assertEqual(size(img), size(bnd));


function test_outer_conn26_3d

img = Image.create(false([5 5 5]));
img(2:4, 2:4, 2:4) = true;

bnd = boundary(img, 26, 'outer');

assertTrue(isa(bnd, 'Image'));
assertEqual(size(img), size(bnd));

exp = Image.create(true([5 5 5]));
exp(2:4, 2:4, 2:4) = false;
assertEqual(0, sum(exp ~= bnd));


function test_conn26_3d

img = Image.create(false([5 5 5]));
img(2:4, 2:4, 2:4) = true;

bnd = boundary(img, 26);

assertTrue(isa(bnd, 'Image'));
assertEqual(size(img), size(bnd));

