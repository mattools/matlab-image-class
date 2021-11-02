function tests = test_regionArea
% Test suite for the file regionArea.
%
%   Test suite for the file regionArea
%
%   Example
%   test_regionArea
%
%   See also
%     regionArea

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-11-02,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function testSquare(testCase)

img = Image.false(10, 10);
img(3:3+4, 4:4+4) = true;

a = regionArea(img);

assertEqual(testCase, 25, a);


function testDelta(testCase)
% Test with a non uniform resolution

img = Image.false(10, 10);
img(3:3+2, 4:4+3) = true;
delta = [3 5];
img.Spacing = delta;

a = regionArea(img, delta);

expectedArea = 3*delta(1) * 4*delta(2); 
assertEqual(testCase, expectedArea, a);


function testLabel(testCase)

% create image with 5 different regions
data = [...
    1 1 1 1 2 2 2 2 ; ...
    1 1 1 1 2 2 2 2 ; ...
    1 1 3 3 3 3 2 2 ; ...
    1 1 3 3 3 3 2 2 ; ...
    4 4 3 3 3 3 5 5 ; ...
    4 4 3 3 3 3 5 5 ; ...
    4 4 4 4 5 5 5 5 ; ...
    4 4 4 4 5 5 5 5 ];
img = Image(data, 'Type', 'label');

a = regionArea(img);

assertEqual(testCase, length(a), 5);
assertEqual(testCase, numel(data), sum(a));


function testLabelImage(testCase)

img = Image.read('coins.png');
lbl = componentLabeling(img > 100);

a = regionArea(lbl);

assertEqual(testCase, 10, length(a));
assertTrue(min(a) > 1500);
assertTrue(max(a) < 3000);
