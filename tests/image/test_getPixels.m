function test_suite = test_getPixels(varargin) %#ok<STOUT>
%TEST_GETPIXELS  One-line description here, please.
%
%   output = test_getPixels(input)
%
%   Example
%   test_getPixels
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

initTestSuite;


function test_getPixels_2d %#ok<*DEFNU>

img = createTestImage2d;

% get one element
assertEqual(0, img.getPixels(1, 1));
assertEqual(1, img.getPixels(2, 1));

% get row
assertEqual([0 1], img.getPixels([1 2], [1 1]));

% get column
assertEqual([0;1], img.getPixels([1;2], [1;1]));


function test_getPixels_3d

img = createTestImage3d;

% get one element
assertEqual(0, img.getPixels(1, 1, 1));
assertEqual(1, img.getPixels(2, 1, 1));
assertEqual(10, img.getPixels(1, 2, 1));
assertEqual(100, img.getPixels(1, 1, 2));

% position and value of some specific voxels
xs = [1 2 1 1];
ys = [1 1 2 1];
zs = [1 1 1 2];
res = [0 1 10 100];

% get row
assertEqual(res, img.getPixels(xs, ys, zs));

% get column
assertEqual(res', img.getPixels(xs', ys', zs'));


function test_getPixels_2dColor

img = createTestImage2dColor;

xs = [1 2 1 2]';
ys = [1 1 2 2]';
res = [...
    0 0 0; ...
    1 0 1; ...
    0 10 10; ...
    1 10 11; ...
    ];

% get one element
assertEqual(res(1,:), img.getPixels(xs(1), ys(1)));
assertEqual(res(2,:), img.getPixels(xs(2), ys(2)));
assertEqual(res(3,:), img.getPixels(xs(3), ys(3)));
assertEqual(res(4,:), img.getPixels(xs(4), ys(4)));

% when inputs are columns, get N-by-3 array
assertEqual(res, img.getPixels(xs, ys));

% when inputs are rows, get 1-by-N-by-3 array
assertEqual(permute(res, [3 1 2]), img.getPixels(xs', ys'));


function test_getPixels_3dColor

img = createTestImage3dColor;

xs = [1 2 1 1]';
ys = [1 1 2 1]';
zs = [1 1 1 2]';
res = [...
    0 0 0; ...
    1 1 0; ...
    10 0 10; ...
    0 100 100; ...
    ];

% get one element
assertEqual(res(1,:), img.getPixels(xs(1), ys(1), zs(1)));
assertEqual(res(2,:), img.getPixels(xs(2), ys(2), zs(2)));
assertEqual(res(3,:), img.getPixels(xs(3), ys(3), zs(3)));
assertEqual(res(4,:), img.getPixels(xs(4), ys(4), zs(4)));

% when inputs are columns, get N-by-3 array
assertEqual(res, img.getPixels(xs, ys, zs));

% when inputs are rows, get 1-by-N-by-3 array
assertEqual(permute(res, [3 1 2]), img.getPixels(xs', ys', zs'));



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
red     = x;
green   = y;
blue    = x + y;

img = Image.create(cat(3, red, green, blue), 'vector', 'true');


function img = createTestImage3d

lx = 0:1:5;
ly = 0:10:30;
lz = 0:100:200;
[x y z] = meshgrid(lx, ly, lz);
dat = x+y+z;

img = Image.create(dat);


function img = createTestImage3dColor

lx = 0:1:5;
ly = 0:10:30;
lz = 0:100:200;
[x y z] = meshgrid(lx, ly, lz);
red     = x + y;
green   = x + z;
blue    = y + z;

img = Image.create(cat(4, red, green, blue), 'vector', 'true');


