function tests = test_regionVolume
% Test suite for the file regionVolume.
%
%   Test suite for the file regionVolume
%
%   Example
%   test_regionVolume
%
%   See also
%     regionVolume

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-11-02,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function testBasic(testCase)

img = Image.false([4 5 6]);
img(2:end-1, 2:end-1, 2:end-1) = true;

v = regionVolume(img);

exp = prod([2 3 4]);
assertEqual(testCase, exp, v);


function testAddBorder(testCase)

img1 = Image.false([7 7 7]);
img1(2:6, 2:6, 2:6) = true;
img2 = Image.true([5 5 5]);

v1 = regionVolume(img1);
v2 = regionVolume(img2);

assertEqual(testCase, v1, v2);


function test_Labels(testCase)

img = Image(zeros([6 6 6]), 'type', 'label');
img(1:3, 1:3, 1:3) = 2;
img(4:6, 1:3, 1:3) = 3;
img(1:3, 4:6, 1:3) = 5;
img(4:6, 4:6, 1:3) = 7;
img(1:3, 1:3, 4:6) = 11;
img(4:6, 1:3, 4:6) = 13;
img(1:3, 4:6, 4:6) = 17;
img(4:6, 4:6, 4:6) = 19;

[vols, labels] = regionVolume(img);
assertEqual(testCase, vols, repmat(27, 8, 1), .01);
assertEqual(testCase, labels, [2 3 5 7 11 13 17 19]');


function test_SelectedLabels(testCase)
% Compute volume on a selection of regions within a label image.

img = Image(zeros([6 6 6]), 'type', 'label');
img(1:3, 1:3, 1:3) = 2;
img(4:6, 1:3, 1:3) = 3;
img(1:3, 4:6, 1:3) = 5;
img(4:6, 4:6, 1:3) = 7;
img(1:3, 1:3, 4:6) = 11;
img(4:6, 1:3, 4:6) = 13;
img(1:3, 4:6, 4:6) = 17;
img(4:6, 4:6, 4:6) = 19;
labels = [2 3 5 7 11 13 17 19]';

vols = regionVolume(img, labels);
assertEqual(testCase, size(vols), [8 1]);
assertEqual(testCase, vols, repmat(27, 8, 1), .01);

vols2 = regionVolume(img, labels(1:2:end));
assertEqual(testCase, size(vols2), [4 1]);
assertEqual(testCase, vols2, repmat(27, 4, 1), .01);


function test_Anisotropic(testCase)

img1 = Image.false([7 7 7]);
img1(2:6, 2:6, 2:6) = true;
img2 = Image.true([5 5 5]);
img1.Spacing = [1 2 3];
img2.Spacing = [1 2 3];

v1 = regionVolume(img1);
v2 = regionVolume(img2);

expectedVolume = (5*5*5) * (1*2*3); % number of elements times voxel volume
assertEqual(testCase, v1, expectedVolume);
assertEqual(testCase, v2, expectedVolume);

