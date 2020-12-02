function tests = test_regionElementCounts
% Test suite for the file regionElementCounts.
%
%   Test suite for the file regionElementCounts
%
%   Example
%   test_regionElementCounts
%
%   See also
%     regionElementCounts

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-02,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_2d(testCase) %#ok<*DEFNU>
% Count the elements in a label image with 4 regions.

data = zeros(10, 10);
data(2, 2) = 1;
data(2, 4:8) = 3;
data(4:8, 2) = 4;
data(4:8, 4:8) = 9;
img = Image('Data', data, 'Type', 'label');

counts = regionElementCounts(img);

assertEqual(testCase, length(counts), 4);
assertEqual(testCase, counts, [1 5 5 25]');


function test_3d(testCase) %#ok<*DEFNU>
% Count the elements in a label image with 4 regions.

data = zeros(10, 10, 10);
data(2, 2, 2) = 1;
data(4:8, 2, 2) = 3;
data(2, 4:8, 2) = 4;
data(2, 2, 4:8) = 5;
data(4:8, 4:8, 2) = 10;
data(4:8, 2, 4:8) = 12;
data(2, 4:8, 4:8) = 15;
data(4:8, 4:8, 4:8) = 19;
img = Image('Data', data, 'Type', 'label');

counts = regionElementCounts(img);

assertEqual(testCase, length(counts), 8);
assertEqual(testCase, counts, [1  5 5 5  25 25 25  125]');

