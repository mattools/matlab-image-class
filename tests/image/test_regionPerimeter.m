function tests = test_regionPerimeter
% Test suite for the file regionPerimeter.
%
%   Test suite for the file regionPerimeter
%
%   Example
%   test_regionPerimeter
%
%   See also
%     regionPerimeter

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-11-02,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_diskR10_D2(testCase)

lx = 1:30;
[x, y] = meshgrid(lx, lx);
img = Image(hypot(x - 15.12, y - 15.23) < 10); 

p = regionPerimeter(img, 2);

% assert perimeter estimate is within 5% of actual value
pTh = 2 * pi * 10;
assertTrue(testCase, abs(p - pTh) < 3);


function test_diskR10_D4(testCase)

lx = 1:30;
[x, y] = meshgrid(lx, lx);
img = Image(hypot(x - 15.12, y - 15.23) < 10); 

p = regionPerimeter(img, 4);

% assert perimeter estimate is within 5% of actual value
pTh = 2 * pi * 10;
assertTrue(testCase, abs(p - pTh) < 3);


function test_touchingBorder_D2(testCase)

img1 = Image.false([7, 7]);
img1(2:6, 2:6) = 1;
img2 = Image.true([5, 5]);

nd  = 2;
p   = regionPerimeter(img1, nd);
pb  = regionPerimeter(img2, nd);

assertEqual(testCase, p, pb);


function test_touchingBorder_D4(testCase)

img1 = Image.false([7, 7]);
img1(2:6, 2:6) = 1;
img2 = Image.true([5, 5]);

nd  = 4;
p   = regionPerimeter(img1, nd);
pb  = regionPerimeter(img2, nd);

assertEqual(testCase, p, pb);


function test_diskR10_D2_Aniso(testCase)

[x, y] = meshgrid(1:2:50, 1:3:50);
img = Image(hypot(x - 25.12, y - 25.23) < 10); 
img.Spacing = [2 3];

p = regionPerimeter(img, 2);

% assert perimeter estimate is within 5% of actual value
pTh = 2 * pi * 10;
assertTrue(testCase, abs(p - pTh) < 3);


function test_diskR10_D4_Aniso(testCase)

[x, y] = meshgrid(1:2:50, 1:3:50);
img = Image(hypot(x - 25.12, y - 25.23) < 10); 
img.Spacing = [2 3];

p = regionPerimeter(img, 4);

% assert perimeter estimate is within 5% of actual value
pTh = 2 * pi * 10;
assertTrue(testCase, abs(p - pTh) < 3);


function test_touchingBorder_D4_Aniso(testCase)

img1 = Image.false([7, 7]);
img1(2:6, 2:6) = 1;
img2 = Image.true([5, 5]);

nd  = 4;
p   = regionPerimeter(img1, nd, [2 3]);
pb  = regionPerimeter(img2, nd, [2 3]);

assertEqual(testCase, p, pb);


function testLabelImage(testCase)

img = Image.read('coins.png');
lbl = componentLabeling(img > 100);

p = regionPerimeter(lbl);

assertEqual(testCase, 10, length(p));
assertTrue(min(p) > 150);
assertTrue(max(p) < 300);

