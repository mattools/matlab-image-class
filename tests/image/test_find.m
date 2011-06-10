function test_suite = test_find(varargin) %#ok<STOUT>
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

initTestSuite;

function test_2d_linear %#ok<*DEFNU>

img = Image.create([0 1 1;1 1 0;1 0 0]);
exp = [2 3 4 5 7]';

assertEqual(exp, find(img));


function test_2d_subs 

img = Image.create([0 1 1;1 1 0;1 0 0]);
expX = [2 3 1 2 1]';
expY = [1 1 2 2 3]';

[x y] = find(img);
assertEqual(expX, x);
assertEqual(expY, y);

function test_3d_linear

img = Image.create(ones([2 2 2]));
exp = (1:8)';
assertEqual(exp, find(img));


function test_3d_sub

img = Image.create(ones([2 2 2]));

[x y z] = find(img);
assertEqual([1 2 1 2 1 2 1 2]', x);
assertEqual([1 1 2 2 1 1 2 2]', y);
assertEqual([1 1 1 1 2 2 2 2]', z);

function test_3d_subVal

img = Image.create(ones([2 2 2]));

[x y z v] = find(img);
assertEqual([1 2 1 2 1 2 1 2]', x);
assertEqual([1 1 2 2 1 1 2 2]', y);
assertEqual([1 1 1 1 2 2 2 2]', z);
assertEqual([1 1 1 1 1 1 1 1]', v);

function test_3d_subVal_last

img = Image.create(reshape(1:60, [4 3 5]));

[x y z v] = find(img, 1, 'last');
assertEqual(3, x);
assertEqual(4, y);
assertEqual(5, z);
assertEqual(60, v);

