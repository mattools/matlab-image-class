function tests = test_medianFilter
% Test suite for the file medianFilter.
%
%   Test suite for the file medianFilter
%
%   Example
%   test_medianFilter
%
%   See also
%     medianFilter

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-11-19,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_2d_Size(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = Image.read('rice.png');

res = medianFilter(img, [3 3]);

assertEqual(testCase, size(res), size(img));


function test_2d_array(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = Image.read('rice.png');

se = [0 1 0;1 1 1;0 1 0];
res = medianFilter(img, se);

assertEqual(testCase, size(res), size(img));


function test_3d_Size(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = Image(ones([7 7 7]));

res = medianFilter(img, [3 3 3]);

assertEqual(testCase, size(res), size(img));

