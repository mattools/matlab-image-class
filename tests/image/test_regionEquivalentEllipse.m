function tests = test_regionEquivalentEllipse
% Test suite for the file regionEquivalentEllipse.
%
%   Test suite for the file regionEquivalentEllipse
%
%   Example
%   test_regionEquivalentEllipse
%
%   See also
%     regionEquivalentEllipse

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-02-02,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = Image.read('circles.png');

elli = regionEquivalentEllipse(img > 0);

assertEqual(testCase, size(elli), [1 5]);


function test_severalLabels(testCase) %#ok<*DEFNU>

% create a label image with four regions
data = zeros([10 10], 'uint8');
data(2:4, 2:4) = 3;
data(6:10, 2:4) = 4;
data(2:4, 6:10) = 7;
data(6:10, 6:10) = 8;
img = Image('Data', data, 'Type', 'Label');

[elli, labels] = regionEquivalentEllipse(img);

assertEqual(testCase, size(elli), [4 5]);
assertEqual(testCase, size(labels), [4 1]);
