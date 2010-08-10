function test_suite = testImage3D(varargin)
% Test function for class Image3D
%   output = testImage3D(input)
%
%   Example
%   testImage3D
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

function testCreateFromArray
% create Image from array, then make some tests on size and getPixel

dim = [10 15 20];
dat = zeros(dim([2 1 3]), 'uint8');
img = Image3D(dat);

assertEqual(dim, img.getSize());

dat = uint8(cat(3, ...
    [1 2 3 4;5 6 7 8;9 10 11 12], ...
    [2 3 4 5;6 7 8 9;10 11 12 13]));
img = Image3D(dat);
dim = [4 3 2];
assertEqual(dim, img.getSize());

% get a pixel
assertEqual(uint8(7), img.getPixel(2, 2, 2));

% get a pixel not on diagonal
assertEqual(uint8(10), img.getPixel(2, 3, 1));



function testIsa

img = Image3D(uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80])));

assertTrue(isa(img, 'Image'));
assertTrue(isa(img, 'Image3D'));


function testSum

img = Image3D(uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80])));
exp = 540;

res = sum(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);

function testMin

img = Image3D(uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80])));
exp = uint8(10);

res = min(img);
assertEqual([1 1], size(res));
assertEqual(exp, res);

% result should have same type as image pixels
assertTrue(isa(res, 'uint8'));

function testMax

img = Image3D(uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80])));
exp = uint8(80);

res = max(img);
assertEqual([1 1], size(res));
assertEqual(exp, res);

% result should have same type as image pixels
assertTrue(isa(res, 'uint8'));

function testMean

img = Image3D(uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80])));
exp = 45;

res = mean(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);


function testMedian

img = Image3D(uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80])));
exp = 45;

res = median(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);


function testVar

dat = cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]);
img = Image3D(uint8(dat));
exp = var(double(dat(:)));

res = var(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);

function testStd

dat = cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]);
img = Image3D(uint8(dat));
exp = std(double(dat(:)));

res = std(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);

function testSetGetSpacing

dat = cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]);
img = Image3D(uint8(dat));
sp = [2.5 3 1.5];
img.setSpacing(sp);

sp2 = img.getSpacing();
assertElementsAlmostEqual(sp, sp2);

function testSetGetOrigin

dat = cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]);
img = Image3D(uint8(dat));

ori = [-5 -10 -2];
img.setOrigin(ori);

ori2 = img.getOrigin();
assertElementsAlmostEqual(ori, ori2);

function testGetXYZ

maxX = 10;
maxY = 15;
maxZ = 20;

dat = ones([maxY maxX maxZ]);
img = Image3D(uint8(dat));
xImg = img.getX();
yImg = img.getY();
zImg = img.getZ();
[x y z] = meshgrid(0:maxX-1, 0:maxY-1, 0:maxZ-1);
assertElementsAlmostEqual(x, xImg);
assertElementsAlmostEqual(y, yImg);
assertElementsAlmostEqual(z, zImg);


function testSubsref

lx = 0:1:5;
ly = 0:10:30;
lz = 0:100:200;
[x y z] = meshgrid(lx, ly, lz);
dat = x+y+z;

img = Image3D(dat);

% get one element
assertEqual(0, img(1));
assertEqual(1, img(2));
assertEqual(235, img(end));

% get one row (y = cte)
assertEqual(img(:, 2, 1), [10 11 12 13 14 15]);

% get last row (y = cte)
assertEqual(img(:, end, 1), [30 31 32 33 34 35]);

% get one column (x = cte)
assertEqual(img(2,:, 1), [1 11 21 31]');

% get last column (x = cte)
assertEqual(img(end,:, 1), [5 15 25 35]');


function testSubsasgn

lx = 0:1:5;
ly = 0:10:30;
lz = 0:100:200;
[x y z] = meshgrid(lx, ly, lz);
dat = x+y+z;

img = Image3D(dat);

% set one element
img(1) = 99;
assertEqual(99, img(1));
img(2) = 99;
assertEqual(99, img(2));
img(end) = 99;
assertEqual(99, img(end));

% get one row (y = cte)
new = 8:2:18;
img(:, 2, 1) = new;
assertEqual(new, img(:, 2, 1));

% get last row (y = cte)
img(:, end, 1) = new;
assertEqual(new, img(:, end, 1));

% get one column (x = cte)
new = (12:3:21)';
img(2, :, 1) = new;
assertEqual(new, img(2, :, 1));

% get last column (x = cte)
img(end, :, 1) = new;
assertEqual(new, img(end, :, 1));

