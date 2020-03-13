function tests = test_splitChannels(varargin)
%TEST_SPLITCHANNELS  Test case for the file splitChannels
%
%   Test case for the file splitChannels

%   Example
%   test_splitChannels
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_Peppers(testCase) %#ok<*DEFNU>
% Test call of function without argument

img = Image.read('peppers.png');
[r, g, b] = splitChannels(img);

% resutls should be grayscale
assertTrue(testCase, isGrayscaleImage(r));
assertTrue(testCase, isGrayscaleImage(g));
assertTrue(testCase, isGrayscaleImage(b));

% results should have same size
assertEqual(testCase, size(img), size(r));
assertEqual(testCase, size(img), size(g));
assertEqual(testCase, size(img), size(b));
