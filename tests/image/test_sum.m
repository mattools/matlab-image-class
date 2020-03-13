function tests = test_sum(varargin)
%test_sum  One-line description here, please.
%
%   output = test_sum(input)
%
%   Example
%   test_sum
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
exp = 210;

res = sum(img);
assertEqual(testCase, [1 1], size(res));
assertEqual(testCase, exp, res, 'AbsTol', 1e-10);

function test_3d(testCase) %#ok<*DEFNU>

dat = uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]));
img = Image.create(dat);
exp = 540;

res = sum(img);
assertEqual(testCase, [1 1], size(res));
assertEqual(testCase, exp, res, 'AbsTol', 1e-10);
