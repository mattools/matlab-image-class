function test_suite = test_size(varargin) %#ok<STOUT>
%TEST_SIZE  Test case for the file size
%
%   Test case for the file size

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

initTestSuite;

function test_gray30x20 %#ok<*DEFNU>
% Test for a grayscale image

data = uint8(zeros(20, 30));
img = Image.create(data);

exp = [30 20];
assertEqual(exp, size(img));

assertEqual(exp(1), size(img, 1));
assertEqual(exp(2), size(img, 2));


function test_several_outputs
% Test for a grayscale image

data = uint8(zeros(20, 30));
img = Image.create(data);

exp = [30 20];
[nx ny] = size(img);

assertEqual(exp(1), nx);
assertEqual(exp(2), ny);

exp = [30 20 1 1 1];
[nx ny nz nc nt] = size(img);
assertEqual(exp(1), nx);
assertEqual(exp(2), ny);
assertEqual(exp(3), nz);
assertEqual(exp(4), nc);
assertEqual(exp(5), nt);


function test_color_image
% Test for a color image

img = Image.read('peppers.png');

exp = [512 384];
assertEqual(exp, size(img));

assertEqual(exp(1), size(img, 1));
assertEqual(exp(2), size(img, 2));


function test_color_image_multiOutput
% Test for a color image

img = Image.read('peppers.png');

exp = [512 384];
[nx ny] = size(img);

assertEqual(exp(1), nx);
assertEqual(exp(2), ny);

exp = [512 384 1 3 1];
[nx ny nz nc nt] = size(img);
assertEqual(exp(1), nx);
assertEqual(exp(2), ny);
assertEqual(exp(3), nz);
assertEqual(exp(4), nc);
assertEqual(exp(5), nt);
