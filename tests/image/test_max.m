function tests = test_max(varargin)
%TEST_MAX  One-line description here, please.
%
%   output = test_max(input)
%
%   Example
%   test_max
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_2d(testCase) %#ok<*DEFNU>

img = Image.create(uint8([10 20 30;40 50 60]));
exp = uint8(60);

res = max(img);
assertEqual(testCase, [1 1], size(res));
assertEqual(testCase, exp, res);

% result should have same type as image pixels
assertTrue(testCase, isa(res, 'uint8'));


function test_2d_color(testCase) 

img = Image.read('peppers.png');

res = max(img);
assertEqual(testCase, [1 3], size(res));


function test_2d_color_2(testCase)

img = Image.read('peppers.png');

res = max(img, 50);
assertTrue(testCase, isa(res, 'Image'));

assertEqual(testCase, [50 50 50], min(res));


function test_3d(testCase)

dat = uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]));
img = Image.create(dat);
exp = uint8(80);

res = max(img);
assertEqual(testCase, [1 1], size(res));
assertEqual(testCase, exp, res);

% result should have same type as image pixels
assertTrue(testCase, isa(res, 'uint8'));


