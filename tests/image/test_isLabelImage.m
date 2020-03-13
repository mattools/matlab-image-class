function tests = test_isLabelImage(varargin)
%TEST_ISLABELImage  Test case for the file isLabelImage
%
%   Test case for the file isLabelImage

%   Example
%   test_isLabelImage
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
res = isLabelImage(img);
assertFalse(testCase, res);
      

function test_rice(testCase)
% Test on a binary image
img = Image.read('rice.png');
img2 = whiteTopHat(img, ones(20, 20));
lbl = componentLabeling(img2 > 50);
res = isLabelImage(lbl);

assertTrue(testCase, res);


function test_color(testCase)
% Test on a color image
img = Image.read('peppers.png');
res = isLabelImage(img);
assertFalse(testCase, res);
