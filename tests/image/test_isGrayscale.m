function test_suite = test_isGrayscale(varargin) %#ok<STOUT>
%TEST_ISGRAYSCALE  Test case for the file isGrayscale
%
%   Test case for the file isGrayscale

%   Example
%   test_isGrayscale
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

initTestSuite;

function test_grayscale %#ok<*DEFNU>
% Test on a grayscale image
img = Image.read('cameraman.tif');
res = isGrayscale(img);
assertTrue(res);
      

function test_binary
% Test on a binary image
img = Image.read('circles.png');
res = isGrayscale(img);
assertTrue(res);


function test_color
% Test on a color image
img = Image.read('peppers.png');
res = isGrayscale(img);
assertFalse(res);
