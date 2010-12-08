function test_suite = test_subsref(varargin) %#ok<STOUT>
%TEST_SUBSREF  One-line description here, please.
%
%   output = test_subsref(input)
%
%   Example
%   test_subsref
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

initTestSuite;


function test_subsref_2d_1arg %#ok<*DEFNU>

img = createTestImage2d;

% get one element
assertEqual(0, img(1));
assertEqual(1, img(2));
assertEqual(35, img(end));


function test_subsref_2d_2args %#ok<*DEFNU>

img = createTestImage2d;

% get one row (y = cte)
assertEqual(img(:, 2), [10 11 12 13 14 15]);

% get last row (y = cte)
assertEqual(img(:, end), [30 31 32 33 34 35]);

% get one column (x = cte)
assertEqual(img(2,:), [1 11 21 31]');

% get last column (x = cte)
assertEqual(img(end,:), [5 15 25 35]');


function test_subsref_3d_1arg

img = createTestImage3d;

% get one element
assertEqual(0, img(1));
assertEqual(1, img(2));
assertEqual(235, img(end));

function test_subsref_3d_3args

img = createTestImage3d;

% get one row (y = cte)
assertEqual(img(:, 2, 1), [10 11 12 13 14 15]);

% get last row (y = cte)
assertEqual(img(:, end, 1), [30 31 32 33 34 35]);

% get one column (x = cte)
assertEqual(img(2,:, 1), [1 11 21 31]');

% get last column (x = cte)
assertEqual(img(end,:, 1), [5 15 25 35]');


function img = createTestImage2d

lx = 0:1:5;
ly = 0:10:30;
[x y] = meshgrid(lx, ly);
dat = x+y;

img = Image.create(dat);


function img = createTestImage2dColor

lx = 0:1:5;
ly = 0:10:30;
[x y] = meshgrid(lx, ly);
red     = x + y;
green   = x - y + 50;
blue    = y - x + 50;

img = Image.create(uint8(cat(3, red, green, blue)), 'vector', 'true');


function img = createTestImage3d

lx = 0:1:5;
ly = 0:10:30;
lz = 0:100:200;
[x y z] = meshgrid(lx, ly, lz);
dat = x+y+z;

img = Image.create(dat);
