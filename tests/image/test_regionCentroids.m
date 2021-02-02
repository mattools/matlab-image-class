function tests = test_regionCentroids
% Test suite for the file regionCentroids.
%
%   Test suite for the file regionCentroids
%
%   Example
%   test_regionCentroids
%
%   See also
%     regionCentroids

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-02-02,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = zeros([10 10], 'uint8');
data(2:4, 2:4) = 3;
data(6:10, 2:4) = 4;
data(2:4, 6:10) = 7;
data(6:10, 6:10) = 8;
img = Image('Data', data, 'Type', 'Label');

[centroids, labels] = regionCentroids(img);

assertEqual(testCase, size(centroids), [4 2]);
assertEqual(testCase, centroids, [3 3;8 3;3 8;8 8]);
assertEqual(testCase, size(labels), [4 1]);
assertEqual(testCase, labels, [3;4;7;8]);


