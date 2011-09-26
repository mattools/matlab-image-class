function test_suite = test_isLabel(varargin) %#ok<STOUT>
%TEST_ISLABEL  Test case for the file isLabel
%
%   Test case for the file isLabel

%   Example
%   test_isLabel
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
res = isLabel(img);
assertFalse(res);
      

function test_rice
% Test on a binary image
img = Image.read('rice.png');
img2 = topHat(img, ones(20, 20));
lbl = labeling(img2 > 50);
res = isLabel(lbl);

assertTrue(res);


function test_color
% Test on a color image
img = Image.read('peppers.png');
res = isLabel(img);
assertFalse(res);
