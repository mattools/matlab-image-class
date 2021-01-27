function tests = test_kmeans
% Test suite for the file kmeans.
%
%   Test suite for the file kmeans
%
%   Example
%   test_kmeans
%
%   See also
%     kmeans

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-27,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = Image.read('peppers.png');

classes = kmeans(img, 6);

assertTrue(testCase, isa(classes, 'Image'));
assertTrue(testCase, isLabelImage(classes));
assertEqual(testCase, max(classes), 6);