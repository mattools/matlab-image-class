function tests = test_isVectorImage(varargin)
%TEST_ISVECTORIMAGE  Test case for the file isVectorImage
%
%   Test case for the file isVectorImage

%   Example
%   test_isVectorImage
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
res = isVectorImage(img);
assertFalse(testCase, res);
      

function test_binary(testCase)
% Test on a binary image
img = Image.read('circles.png');
res = isVectorImage(img);
assertFalse(testCase, res);


function test_color(testCase)
% Test on a color image
img = Image.read('peppers.png');
res = isVectorImage(img);
assertTrue(testCase, res);
