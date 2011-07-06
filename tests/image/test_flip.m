function test_suite = test_flip(varargin) %#ok<STOUT>
%TEST_FLIP  One-line description here, please.
%
%   output = test_flip(input)
%
%   Example
%   test_flip
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

initTestSuite;

function test_gray1 %#ok<*DEFNU>

img = Image.read('cameraman.tif');

img2 = flip(img, 1);
assertElementsAlmostEqual([256 256], size(img2));

function test_gray2 %#ok<*DEFNU>

img = Image.read('cameraman.tif');
img2 = flip(img, 2);
assertElementsAlmostEqual([256 256], size(img2));

function test_color1

img = Image.read('peppers.png');
dim = size(img);

img2 = flip(img, 1);
assertElementsAlmostEqual(dim, size(img2));
