function test_suite = test_crop(varargin) %#ok<STOUT>
%test_crop Test file for crop function
%
%   output = test_crop(input)
%
%   Example
%   test_crop
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

initTestSuite;

function test_2d  %#ok<*DEFNU>

img = Image.read('cameraman.tif');

img2 = img.crop([51 200 51 150]);

assertElementsAlmostEqual([150 100], size(img2));
