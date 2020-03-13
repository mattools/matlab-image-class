function tests = test_isGrayscaleImage(varargin)
%TEST_ISGRAYSCALEIMAGE  Test case for the file isGrayscaleImage
%
%   Test case for the file isGrayscaleImage

%   Example
%   test_isGrayscaleImage
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_grayscale(testCase) %#ok<*DEFNU>
% Test on a grayscale image
img = Image.read('cameraman.tif');
res = isGrayscaleImage(img);
assertTrue(testCase, res);
      

function test_binary(testCase)
% Test on a binary image
img = Image.read('circles.png');
res = isGrayscaleImage(img);
assertTrue(testCase, res);


function test_color(testCase)
% Test on a color image
img = Image.read('peppers.png');
res = isGrayscaleImage(img);
assertFalse(testCase, res);
