function tests = test_crop(varargin)
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

tests = functiontests(localfunctions);

function test_2d(testCase)  %#ok<*DEFNU>

img = Image.read('cameraman.tif');
clearCalibration(img);

img2 = img.crop([51 200 51 150]);

assertEqual(testCase, [150 100], size(img2));
