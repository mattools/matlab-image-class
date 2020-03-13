function tests = test_find(varargin)
%TEST_FIND  One-line description here, please.
%
%   output = test_find(input)
%
%   Example
%   test_find
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_2d_linear(testCase) %#ok<*DEFNU>

img = Image.create([0 1 1;1 1 0;1 0 0]);
exp = [2 3 4 5 7]';

assertEqual(testCase, exp, find(img));


function test_2d_subs(testCase)

img = Image.create([0 1 1;1 1 0;1 0 0]);
expX = [2 3 1 2 1]';
expY = [1 1 2 2 3]';

[x, y] = find(img);
assertEqual(testCase, expX, x);
assertEqual(testCase, expY, y);


function test_2d_subVal(testCase)

img = Image.create([0 3 4;2 3 0;1 0 0]);
expX = [2 3 1 2 1]';
expY = [1 1 2 2 3]';
expV = [3 4 2 3 1]';

[x, y, v] = find(img);
assertEqual(testCase, expX, x);
assertEqual(testCase, expY, y);
assertEqual(testCase, expV, v);


function test_2d_subVal_first(testCase)

img = Image.create([0 3 4;2 3 0;1 0 0]);
expX = 2;
expY = 1;
expV = 3;

[x, y, v] = find(img, 1, 'first');
assertEqual(testCase, expX, x);
assertEqual(testCase, expY, y);
assertEqual(testCase, expV, v);


function test_2d_subVal_last(testCase)

img = Image.create([0 3 4;2 3 0;5 0 0]);
expX = 1;
expY = 3;
expV = 5;

[x, y, v] = find(img, 1, 'last');
assertEqual(testCase, expX, x);
assertEqual(testCase, expY, y);
assertEqual(testCase, expV, v);


function test_3d_linear(testCase)

img = Image.create(ones([2 2 2]));
exp = (1:8)';
assertEqual(testCase, exp, find(img));


function test_3d_sub(testCase)

img = Image.create(ones([2 2 2]));

[x, y, z] = find(img);
assertEqual(testCase, [1 2 1 2 1 2 1 2]', x);
assertEqual(testCase, [1 1 2 2 1 1 2 2]', y);
assertEqual(testCase, [1 1 1 1 2 2 2 2]', z);

function test_3d_subVal(testCase)

img = Image.create(ones([2 2 2]));

[x, y, z, v] = find(img);
assertEqual(testCase, [1 2 1 2 1 2 1 2]', x);
assertEqual(testCase, [1 1 2 2 1 1 2 2]', y);
assertEqual(testCase, [1 1 1 1 2 2 2 2]', z);
assertEqual(testCase, [1 1 1 1 1 1 1 1]', v);


function test_3d_subVal_first(testCase)

img = Image.create(reshape(1:60, [4 3 5]));

[x, y, z, v] = find(img, 1, 'first');
assertEqual(testCase, 1, x);
assertEqual(testCase, 1, y);
assertEqual(testCase, 1, z);
assertEqual(testCase, 1, v);


function test_3d_subVal_last(testCase)

img = Image.create(reshape(1:60, [4 3 5]));

[x, y, z, v] = find(img, 1, 'last');
assertEqual(testCase, 3, x);
assertEqual(testCase, 4, y);
assertEqual(testCase, 5, z);
assertEqual(testCase, 60, v);

