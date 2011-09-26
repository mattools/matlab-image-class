function test_suite = test_isVector(varargin) %#ok<STOUT>
%TEST_ISVECTOR  Test case for the file isVector
%
%   Test case for the file isVector

%   Example
%   test_isVector
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
res = isVector(img);
assertFalse(res);
      

function test_binary
% Test on a binary image
img = Image.read('circles.png');
res = isVector(img);
assertFalse(res);


function test_color
% Test on a color image
img = Image.read('peppers.png');
res = isVector(img);
assertTrue(res);
