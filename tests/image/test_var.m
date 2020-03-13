function tests = test_var(varargin)
%TEST_VAR  One-line description here, please.
%
%   output = test_var(input)
%
%   Example
%   test_var
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

dat = [10 20 30;40 50 60;70 80 90];
img = Image.create(uint8(dat));
exp = var(double(dat(:)));

res = var(img);
assertEqual([1 1], size(res));
assertEqual(testCase, exp, res, 'AbsTol', 1e-10);

function test_3d(testCase)

dat = cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]);
img = Image.create(uint8(dat));
exp = var(double(dat(:)));

res = var(img);
assertEqual([1 1], size(res));
assertEqual(testCase, exp, res, 'AbsTol', 1e-10);


