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



function test_3d_ball_C6(testCase)

% create a simple ball
img = Image.false([5 5 5]);
img(2:4, 2:4, 2:4) = true;

% check EPC=1
epcTh = 1;
assertEqual(testCase, epcTh, regionEulerNumber(img, 6));

% add a hole in the ball -> EPC=2
img(3, 3, 3) = false;

% check EPC=2
epcTh  = 2;
assertEqual(testCase, epcTh, regionEulerNumber(img, 6));


function test_3d_ball_C26(testCase)

% create a simple ball
img = Image.false([5 5 5]);
img(2:4, 2:4, 2:4) = true;

% check EPC=1
epcTh = 1;
assertEqual(testCase, epcTh, regionEulerNumber(img, 26));

% add a hole in the ball -> EPC=2
img(3, 3, 3) = false;

% check EPC=2
epcTh  = 2;
assertEqual(testCase, epcTh, regionEulerNumber(img, 26));



function test_3d_torus_C6(testCase)

% create a simple ball
img = Image.false([5 5 5]);
img(2:4, 2:4, 2:4) = true;
img(3, 3, 2:4) = false;

% check EPC=0
epcTh = 0;
assertEqual(testCase, epcTh, regionEulerNumber(img, 6));


function test_3d_torus_C26(testCase)

% create a simple ball
img = Image.false([5 5 5]);
img(2:4, 2:4, 2:4) = true;
img(3, 3, 2:4) = false;

% check EPC=0
epcTh = 0;
assertEqual(testCase, epcTh, regionEulerNumber(img, 26));


function test_3D_cubeDiagonals_C6(testCase)

% create a small 3D image with points along cube diagonal
img = Image.false([5 5 5]);
for i = 1:5
    img(i, i, i) = true;
    img(6-i, i, i) = true;
    img(i, 6-i, i) = true;
    img(6-i, 6-i, i) = true;
end

epc6 = regionEulerNumber(img, 6);

epc6Th = 17;
assertEqual(testCase, epc6, epc6Th);


function test_3D_cubeDiagonals_C26(testCase)

% create a small 3D image with points along cube diagonal
img = Image.false([7 7 7]);
for i = 2:6
    img(i, i, i) = true;
    img(8-i, i, i) = true;
    img(i, 8-i, i) = true;
    img(8-i, 8-i, i) = true;
end

epc26 = regionEulerNumber(img, 26);

epc26Th = 1;
assertEqual(testCase, epc26, epc26Th);


function test_3D_cubeDiagonals_touchingBorder_C26(testCase)

% create a small 3D image with points along cube diagonal
img = Image.false([5 5 5]);
for i = 1:5
    img(i, i, i) = true;
    img(6-i, i, i) = true;
    img(i, 6-i, i) = true;
    img(6-i, 6-i, i) = true;
end

epc26 = regionEulerNumber(img, 26);

epc26Th = 1;
assertEqual(testCase, epc26, epc26Th);

