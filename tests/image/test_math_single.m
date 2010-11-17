function test_suite = test_math_single(varargin) %#ok<STOUT>
%TEST_MATH_SINGLE Test mean, max.. computed on whole image
%
%   output = test_math_single(input)
%
%   Example
%   test_math_single
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


function test_sum %#ok<*DEFNU>

img = Image.create(uint8([10 20 30;40 50 60]));
exp = 210;

res = sum(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);


dat = uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]));
img = Image.create(dat);
exp = 540;

res = sum(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);


function test_min

img = Image.create(uint8([10 20 30;40 50 60]));
exp = uint8(10);

res = min(img);
assertEqual([1 1], size(res));
assertEqual(exp, res);

% result should have same type as image pixels
assertTrue(isa(res, 'uint8'));

dat = uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]));
img = Image.create(dat);
exp = uint8(10);

res = min(img);
assertEqual([1 1], size(res));
assertEqual(exp, res);

% result should have same type as image pixels
assertTrue(isa(res, 'uint8'));


function test_max

img = Image.create(uint8([10 20 30;40 50 60]));
exp = uint8(60);

res = max(img);
assertEqual([1 1], size(res));
assertEqual(exp, res);

% result should have same type as image pixels
assertTrue(isa(res, 'uint8'));


dat = uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]));
img = Image.create(dat);
exp = uint8(80);

res = max(img);
assertEqual([1 1], size(res));
assertEqual(exp, res);

% result should have same type as image pixels
assertTrue(isa(res, 'uint8'));


function test_mean

img = Image.create(uint8([10 20 30;40 50 60]));
exp = 35;

res = mean(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);

dat = uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]));
img = Image.create(dat);
exp = 45;

res = mean(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);


function test_median

img = Image.create(uint8([10 20 30;40 50 60;70 80 90]));
exp = 50;

res = median(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);


dat = uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]));
img = Image.create(dat);
exp = 45;

res = median(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);


function test_var

dat = [10 20 30;40 50 60;70 80 90];
img = Image.create(uint8(dat));
exp = var(double(dat(:)));

res = var(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);

dat = cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]);
img = Image.create(uint8(dat));
exp = var(double(dat(:)));

res = var(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);


function test_std

dat = [10 20 30;40 50 60;70 80 90];
img = Image.create(uint8(dat));
exp = std(double(dat(:)));

res = std(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);

dat = cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]);
img = Image.create(uint8(dat));
exp = std(double(dat(:)));

res = std(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);

