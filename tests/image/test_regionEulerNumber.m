function tests = test_regionEulerNumber
% Test suite for the file regionEulerNumber.
%
%   Test suite for the file regionEulerNumber
%
%   Example
%   test_regionEulerNumber
%
%   See also
%     regionEulerNumber

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-11-02,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_2d_SimplePoints(testCase)
% Four points in a black image.

img = Image.false([10 10]);
img(3, 4) = true;
img(7, 8) = true;
img(1, 2) = true;
img(10, 2) = true;

epc = regionEulerNumber(img);

assertEqual(testCase, 4, epc);


function test_2d_BorderPoints(testCase)
% Five points in a black image, on the boundary.

img = Image.false([10 10]);
img(1, 2) = true;
img(10, 2) = true;
img(6, 10) = true;
img(4, 10) = true;
img(10, 10) = true;

epc = regionEulerNumber(img);

assertEqual(testCase, 5, epc);


function test_2d_Conn8(testCase)
% test with 3 points touching by corner.

img = Image.false([10 10]);
img(3, 4) = true;
img(4, 5) = true;
img(5, 4) = true;

epc4 = regionEulerNumber(img);
epc8 = regionEulerNumber(img, 8);

assertEqual(testCase, 3, epc4);
assertEqual(testCase, 1, epc8);


function test_2d_Labels(testCase)
% Label images with several regions return vector of results.

% create a label image with 3 labels, one of them with a hole
img = Image(zeros([10 10]), 'Type', 'Label');
img(2:3, 2:3) = 3;
img(6:8, 2:3) = 5;
img(3:5, 5:8) = 9;
img(4, 6) = 0;

[chi, labels] = regionEulerNumber(img);

assertEqual(testCase, chi, [1 1 0]');
assertEqual(testCase, labels, [3 5 9]');



