function tests = test_permute(varargin)
%TEST_PERMUTE  One-line description here, please.
%
%   output = test_permute(input)
%
%   Example
%   test_permute
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-06-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);


function test_cameraman_yx(testCase) %#ok<*DEFNU>

img = Image.read('cameraman.tif');

inv = permute(img, [2 1]);

assertEqual(testCase, size(img), size(inv));


function test_peppers_yx(testCase)

img = Image.read('peppers.png');

inv = permute(img, [2 1 3 4]);

dims = size(img);
assertEqual(testCase, size(inv), dims([2 1]));


function test_peppers_xyzc(testCase)

img = Image.read('peppers.png');

inv = permute(img, [1 2 4 3]);

dims = [size(img) 1 channelCount(img)];
assertEqual(testCase, size(inv), dims([1 2 4]));

assertTrue(testCase, is3dImage(inv));

