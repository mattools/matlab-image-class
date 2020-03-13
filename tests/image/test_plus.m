function tests = test_plus(varargin)
%TEST_PLUS  Test case for the file plus
%
%   Test case for the file plus

%   Example
%   test_plus
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_TwoImages(testCase) %#ok<*DEFNU>

img1 = Image.create([1 2 3 4;5 6 7 8;9 10 11 12]);
img2 = Image.create(ones(3, 4));

exp = Image.create([2 3 4 5;6 7 8 9;10 11 12 13]);
res = img1 + img2;
assertEqual(testCase, exp.Data, res.Data);

function test_AddConstant(testCase)

img1 = Image.create([1 2 3 4;5 6 7 8;9 10 11 12]);

exp = Image.create([3 4 5 6; 7 8 9 10; 11 12 13 14]);

res = img1 + 2;
assertElementsAlmostEqual(exp.Data, res.Data);

res = 2 + img1;
assertEqual(testCase, exp.Data, res.Data);

function test_Images3d(testCase)

img1 = Image.create(uint8(200*ones([2 3 4])));

img2 = Image.create(uint8(zeros([2 3 4])));
img2(2, 2, 2) = 100;

res = img1 + img2;
exp = Image.create(uint8(200*ones([2 3 4])));
exp(2, 2, 2) = 255;
assertEqual(testCase, 0, sum(absdiff(exp, res)));


