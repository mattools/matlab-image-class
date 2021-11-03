function tests = test_regionSurfaceArea
% Test suite for the file regionSurfaceArea.
%
%   Test suite for the file regionSurfaceArea
%
%   Example
%   test_regionSurfaceArea
%
%   See also
%     regionSurfaceArea

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-11-02,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_ball_D3(testCase)

[x, y, z] = meshgrid(1:30, 1:30, 1:30);
img = Image(sqrt((x-15.12).^2 + (y-15.23).^2 + (z-15.34).^2) < 10);

s = regionSurfaceArea(img, 3);

sth = 4 * pi * 10^2;
assertTrue(testCase, abs(s - sth) < sth * 0.05);


function test_ball_D13(testCase)

[x, y, z] = meshgrid(1:30, 1:30, 1:30);
img = Image(sqrt((x-15.12).^2 + (y-15.23).^2 + (z-15.34).^2) < 10);

s = regionSurfaceArea(img, 13);

sth = 4 * pi * 10^2;
assertTrue(testCase, abs(s - sth) < sth * 0.05);


function test_ball_D3_aniso(testCase)

[x, y, z] = meshgrid(1:30, 1:2:30, 1:3:30);
img = Image(sqrt((x-15.12).^2 + (y-15.23).^2 + (z-15.34).^2) < 10);
img.Spacing = [1 2 3];

s = regionSurfaceArea(img, 3);

sth = 4 * pi * 10^2;
assertTrue(testCase, abs(s - sth) < sth * 0.05);


function test_ball_D13_aniso(testCase)

[x, y, z] = meshgrid(1:30, 1:2:30, 1:3:30);
img = Image(sqrt((x-15.12).^2 + (y-15.23).^2 + (z-15.34).^2) < 10);
img.Spacing = [1 2 3];

s = regionSurfaceArea(img, 13);

sth = 4 * pi * 10^2;
assertTrue(testCase, abs(s - sth) < sth * 0.05);


function test_TouchingBorder_D3(testCase)

img1 = Image.false([7 7 7]);
img1(2:6, 2:6, 2:6) = true;
img2 = Image.true([5 5 5]);

s1 = regionSurfaceArea(img1, 3);
s2 = regionSurfaceArea(img2, 3);

assertEqual(testCase, s1, s2);


function test_TouchingBorder_D13(testCase)

img1 = Image.false([7 7 7]);
img1(2:6, 2:6, 2:6) = true;
img2 = Image.true([5 5 5]);

s1 = regionSurfaceArea(img1, 13);
s2 = regionSurfaceArea(img2, 13);

assertEqual(testCase, s1, s2);


function test_Labels_D3(testCase)

img = Image(zeros([5 5 5]), 'type', 'label');
img(1:3, 1:3, 1:3) = 1;
img(4:5, 1:3, 1:3) = 2;
img(1:3, 4:5, 1:3) = 3;
img(4:5, 4:5, 1:3) = 4;
img(1:3, 1:3, 4:5) = 5;
img(4:5, 1:3, 4:5) = 6;
img(1:3, 4:5, 4:5) = 7;
img(4:5, 4:5, 4:5) = 8;

s3 = regionSurfaceArea(img, 3);
assertEqual(testCase, 8, length(s3));


function test_Labels_D13(testCase)

img = Image(zeros([5 5 5]), 'type', 'label');
img(1:3, 1:3, 1:3) = 1;
img(4:5, 1:3, 1:3) = 2;
img(1:3, 4:5, 1:3) = 3;
img(4:5, 4:5, 1:3) = 4;
img(1:3, 1:3, 4:5) = 5;
img(4:5, 1:3, 4:5) = 6;
img(1:3, 4:5, 4:5) = 7;
img(4:5, 4:5, 4:5) = 8;

s13 = regionSurfaceArea(img, 13);
assertEqual(testCase, 8, length(s13));


function test_LabelSelection_D3(testCase)

img = Image(zeros([5 5 5]), 'type', 'label');
img(1:3, 1:3, 1:3) = 2;
img(4:5, 1:3, 1:3) = 3;
img(1:3, 4:5, 1:3) = 5;
img(4:5, 4:5, 1:3) = 7;
img(1:3, 1:3, 4:5) = 11;
img(4:5, 1:3, 4:5) = 13;
img(1:3, 4:5, 4:5) = 17;
img(4:5, 4:5, 4:5) = 19;

[b3, labels3] = regionSurfaceArea(img, 3);

assertEqual(testCase, 8, length(b3));
assertEqual(testCase, 8, length(labels3));
assertEqual(testCase, labels3, [2 3 5 7 11 13 17 19]');


function test_LabelSelection_D13(testCase)

img = Image(zeros([5 5 5]), 'type', 'label');
img(1:3, 1:3, 1:3) = 2;
img(4:5, 1:3, 1:3) = 3;
img(1:3, 4:5, 1:3) = 5;
img(4:5, 4:5, 1:3) = 7;
img(1:3, 1:3, 4:5) = 11;
img(4:5, 1:3, 4:5) = 13;
img(1:3, 4:5, 4:5) = 17;
img(4:5, 4:5, 4:5) = 19;

[s13, labels13] = regionSurfaceArea(img, 13);

assertEqual(testCase, 8, length(s13));
assertEqual(testCase, 8, length(labels13));
assertEqual(testCase, labels13, [2 3 5 7 11 13 17 19]');
