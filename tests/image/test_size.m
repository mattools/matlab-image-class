function tests = test_size(varargin)
%TEST_SIZE  Test case for the file size
%
%   Test case for the file size
%
%   Example
%   test_size
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_gray30x20(testCase) %#ok<*DEFNU>
% Test for a grayscale image

data = uint8(zeros(20, 30));
img = Image.create(data);

exp = [30 20];
assertEqual(testCase, exp, size(img));

assertEqual(testCase, exp(1), size(img, 1));
assertEqual(testCase, exp(2), size(img, 2));


function test_several_outputs(testCase)
% Test for a grayscale image

data = uint8(zeros(20, 30));
img = Image.create(data);

exp = [30 20];
[nx, ny] = size(img);

assertEqual(testCase, exp(1), nx);
assertEqual(testCase, exp(2), ny);

exp = [30 20 1 1 1];
[nx, ny, nz, nc, nt] = size(img);
assertEqual(testCase, exp(1), nx);
assertEqual(testCase, exp(2), ny);
assertEqual(testCase, exp(3), nz);
assertEqual(testCase, exp(4), nc);
assertEqual(testCase, exp(5), nt);


function test_color_image(testCase)
% Test for a color image

img = Image.read('peppers.png');

exp = [512 384];
assertEqual(testCase, exp, size(img));

assertEqual(testCase, exp(1), size(img, 1));
assertEqual(testCase, exp(2), size(img, 2));


function test_color_image_multiOutput(testCase)
% Test for a color image

img = Image.read('peppers.png');

exp = [512 384];
[nx, ny] = size(img);

assertEqual(testCase, exp(1), nx);
assertEqual(testCase, exp(2), ny);

exp = [512 384 1 3 1];
[nx, ny, nz, nc, nt] = size(img);
assertEqual(testCase, exp(1), nx);
assertEqual(testCase, exp(2), ny);
assertEqual(testCase, exp(3), nz);
assertEqual(testCase, exp(4), nc);
assertEqual(testCase, exp(5), nt);
