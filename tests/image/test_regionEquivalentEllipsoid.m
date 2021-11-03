function tests = test_regionEquivalentEllipsoid
% Test suite for the file regionEquivalentEllipsoid.
%
%   Test suite for the file regionEquivalentEllipsoid
%
%   Example
%   test_regionEquivalentEllipsoid
%
%   See also
%     regionEquivalentEllipsoid

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-11-03,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

fileName = 'ellipsoid_Center30x27x25_Size20x12x8_Orient40x30x20.tif';
img = Image.read(fullfile('files', fileName));

elli = regionEquivalentEllipsoid(img > 0);

assertEqual(testCase, size(elli), [1 9]);
assertEqual(testCase, [30 27 25], elli(1:3), 'AbsTol', 0.5);
assertEqual(testCase, [20 12  8], elli(4:6), 'AbsTol', 0.5);
assertEqual(testCase, [40 30 20], elli(7:9), 'AbsTol', 0.5);


function test_Calibrated(testCase) %#ok<*DEFNU>
% Test call of function without argument.

fileName = 'ellipsoid_Center30x27x25_Size20x12x8_Orient40x30x20.tif';
img = Image.read(fullfile('files', fileName));
img.Spacing = [0.5 0.5 0.5];
img.Origin  = [0.5 0.5 0.5];

elli = regionEquivalentEllipsoid(img > 0);

assertEqual(testCase, size(elli), [1 9]);
assertEqual(testCase, [15 13.5 12.5], elli(1:3), 'AbsTol', 0.5);
assertEqual(testCase, [10 6 4], elli(4:6), 'AbsTol', 0.5);
assertEqual(testCase, [40 30 20], elli(7:9), 'AbsTol', 0.5);


