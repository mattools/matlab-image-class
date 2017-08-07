function test_suite = test_isColorImage(varargin)
%TEST_ISCOLORIMAGE  Test case for the file isColorImage
%
%   Test case for the file isColorImage

%   Example
%   test_isColorImage
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_grayscale %#ok<*DEFNU>
% Test on a grayscale image
img = Image.read('cameraman.tif');
res = isColorImage(img);
assertFalse(res);
      

function test_binary
% Test on a binary image
img = Image.read('circles.png');
res = isColorImage(img);
assertFalse(res);


function test_color
% Test on a color image
img = Image.read('peppers.png');
res = isColorImage(img);
assertTrue(res);
