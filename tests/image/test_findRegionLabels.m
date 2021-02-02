function tests = test_findRegionLabels
% Test suite for the file findRegionLabels.
%
%   Test suite for the file findRegionLabels
%
%   Example
%   test_findRegionLabels
%
%   See also
%     findRegionLabels

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-02-02,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = zeros([10 6], 'uint8');
data(1:2,1:2) = 3;
data(4:8,1:2) = 4;
data(2:5,4:5) = 7;
data(7:10,5:6) = 8;
img = Image('Data', data, 'Type', 'Label');

labels = findRegionLabels(img);

assertEqual(testCase, labels, [3 4 7 8]');


