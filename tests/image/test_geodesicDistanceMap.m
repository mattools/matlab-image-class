function tests = test_geodesicDistanceMap
% Test suite for the file geodesicDistanceMap.
%
%   Test suite for the file geodesicDistanceMap
%
%   Example
%   test_geodesicDistanceMap
%
%   See also
%     geodesicDistanceMap

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-10-19,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

%% Tests for markers at various corner positions

function test_MarkerAtUpperLeftCorner_10x12(testCase) %#ok<*DEFNU>
% use blank image, marker at the upper left corner.

mask = Image.true([10 12]);
marker = Image.false(size(mask));
marker(1, 1) = 1;

dist = geodesicDistanceMap(marker, mask, [1 0]);
maxDist = max(dist(mask));

assertTrue(isfinite(maxDist));

expDist = 10+12-2;
assertEqual(testCase, expDist, maxDist);

function test_MarkerAtBottomRightCorner_10x12(testCase) %#ok<*DEFNU>
% use blank image, marker at the upper left corner.

mask = Image.true([10 12]);
marker = Image.false(size(mask));
marker(end, end) = 1;

dist = geodesicDistanceMap(marker, mask, [1 0]);
maxDist = max(dist(mask));

assertTrue(isfinite(maxDist));

expDist = 10+12-2;
assertEqual(testCase, expDist, maxDist);


function test_MarkerAtUpperLeftCorner_10x30(testCase) %#ok<*DEFNU>
% use blank image, marker at the upper left corner.

mask = Image.true([10 30]);
marker = Image.false(size(mask));
marker(1, 1) = 1;

dist = geodesicDistanceMap(marker, mask, [1 1]);
maxDist = max(dist(mask));

assertTrue(isfinite(maxDist));

expDist = 29;
assertEqual(testCase, expDist, maxDist);


function test_MarkerAtBottomRightCorner_10x30(testCase) %#ok<*DEFNU>
% use blank image, marker at the upper left corner.

mask = Image.true([10 30]);
marker = Image.false(size(mask));
marker(end, end) = 1;

dist = geodesicDistanceMap(marker, mask, [1 1]);
maxDist = max(dist(mask));

assertTrue(isfinite(maxDist));

expDist = 29;
assertEqual(testCase, expDist, maxDist);


function test_FiniteDistWithMarkerOutside(testCase)

mask = Image([...
    0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0; ...
    0 1 1 1 1 1 1 1 1 0; ...
    0 0 0 0 0 0 0 1 1 0; ...
    0 0 1 1 1 1 0 0 1 0; ...
    0 1 0 0 0 1 0 0 1 0; ...
    0 1 1 0 0 0 0 1 1 0; ...
    0 0 1 1 1 1 1 1 1 0; ...
    0 0 0 0 1 1 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0]);
    
marker = Image.false(size(mask));
marker(2, 2) = 1;

dist = imGeodesicDistanceMap(marker, mask);
maxDist = max(dist(isfinite(dist)));

assertTrue(isfinite(maxDist));
