function test_suite = test_isIntensityImage(varargin) %#ok<STOUT>
%TEST_ISINTENSITYIMAGE  Test case for the file isIntensity
%
%   Test case for the file isIntensityImage

%   Example
%   test_isIntensityImage
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
res = isIntensityImage(img);
assertFalse(res);
      

function test_rice
% Test on a binary image

img = Image.read('rice.png');
grad = norm(gradient(img));
res = isIntensityImage(grad);

assertTrue(res);


function test_color
% Test on a color image
img = Image.read('peppers.png');
res = isIntensityImage(img);
assertFalse(res);
