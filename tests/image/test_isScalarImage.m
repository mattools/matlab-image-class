function tests = test_isScalarImage(varargin)
%TEST_ISSCALARImage  Test case for the file isScalarImage
%
%   Test case for the file isScalarImage

%   Example
%   test_isScalarImage
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
res = isScalarImage(img);
assertTrue(testCase, res);
      

function test_binary(testCase)
% Test on a binary image
img = Image.read('circles.png');
res = isScalarImage(img);
assertTrue(testCase, res);


function test_color(testCase)
% Test on a color image
img = Image.read('peppers.png');
res = isScalarImage(img);
assertFalse(testCase, res);
