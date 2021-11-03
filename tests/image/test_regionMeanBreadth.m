function tests = test_regionMeanBreadth
% Test suite for the file regionMeanBreadth.
%
%   Test suite for the file regionMeanBreadth
%
%   Example
%   test_regionMeanBreadth
%
%   See also
%     regionMeanBreadth

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-11-02,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_ball_D3(testCase)

[x, y, z] = meshgrid(1:30, 1:30, 1:30);
img = Image(sqrt((x-15.12).^2 + (y-15.23).^2 + (z-15.34).^2) < 10);

mb = regionMeanBreadth(img, 3);

mbth = 2 * 10;
assertTrue(testCase, abs(mb - mbth) < mbth * 0.05);


function test_ball_D13(testCase)

[x, y, z] = meshgrid(1:30, 1:30, 1:30);
img = Image(sqrt((x-15.12).^2 + (y-15.23).^2 + (z-15.34).^2) < 10);

mb = regionMeanBreadth(img, 13);

mbth = 2 * 10;
assertTrue(testCase, abs(mb - mbth) < mbth * 0.05);


function test_ball_D3_aniso(testCase)

[x, y, z] = meshgrid(1:30, 1:2:30, 1:3:30);
img = Image(sqrt((x-15.12).^2 + (y-15.23).^2 + (z-15.34).^2) < 10);
img.Spacing = [1 2 3];

mb = regionMeanBreadth(img, 3);

mbth = 2 * 10;
assertTrue(testCase, abs(mb - mbth) < mbth * 0.05);


function test_ball_D13_aniso(testCase)

[x, y, z] = meshgrid(1:30, 1:2:30, 1:3:30);
img = Image(sqrt((x-15.12).^2 + (y-15.23).^2 + (z-15.34).^2) < 10);
img.Spacing = [1 2 3];

mb = regionMeanBreadth(img, 13);

mbth = 2 * 10;
assertTrue(testCase, abs(mb - mbth) < mbth * 0.05);


function test_TouchingBorder_D3(testCase)

img1 = Image.false([7 7 7]);
img1(2:6, 2:6, 2:6) = true;
img2 = Image.true([5 5 5]);

mb1 = regionMeanBreadth(img1, 3);
mb2 = regionMeanBreadth(img2, 3);

assertEqual(testCase, mb1, mb2);


function test_TouchingBorder_D13(testCase)

img1 = Image.false([7 7 7]);
img1(2:6, 2:6, 2:6) = true;
img2 = Image.true([5 5 5]);

mb1 = regionMeanBreadth(img1, 13);
mb2 = regionMeanBreadth(img2, 13);

assertEqual(testCase, mb1, mb2);



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

[mb, labels] = regionMeanBreadth(img);
assertEqual(testCase, size(mb), [8 1], .01);
assertEqual(testCase, labels, [2 3 5 7 11 13 17 19]');


function test_LabelSelection(testCase)

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

mb = regionMeanBreadth(img, labels);
assertEqual(testCase, size(mb), [8 1]);

mb2 = regionMeanBreadth(img, labels(1:2:end));
assertEqual(testCase, size(mb2), [4 1]);
