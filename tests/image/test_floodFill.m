function tests = test_floodFill
%TEST_FLOODFILL  Test case for the file floodFill
%
%   Test case for the file floodFill
%
%   Example
%   test_floodFill
%
%   See also
%   floodFill

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-02-11,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_2d(testCase) %#ok<*DEFNU>
% Test for planar case

data = kron([1 2 ; 3 4], ones(3,3));
img = Image(data);
res = floodFill(img, [5 5], 6);

assertTrue(testCase, res(4,4) == 6);
assertTrue(testCase, res(6,6) == 6);


function test_3d(testCase)
% Test for 3D case

data = cat(3, repmat(kron([1 2;3 4], ones(3,3)), [1 1 3]), repmat(kron([5 6;7 8], ones(3,3)), [1 1 3]));
img = Image(data);
res = floodFill(img, [5 5 5], 9);

assertTrue(testCase, res(4,4,4) == 9);
assertTrue(testCase, res(6,6,6) == 9);
