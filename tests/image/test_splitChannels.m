function test_suite = test_splitChannels(varargin) %#ok<STOUT>
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

initTestSuite;

function test_Peppers %#ok<*DEFNU>
% Test call of function without argument

img = Image.read('peppers.png');
[r g b] = splitChannels(img);

% resutls should be grayscale
assertTrue(isGrayscaleImage(r));
assertTrue(isGrayscaleImage(g));
assertTrue(isGrayscaleImage(b));

% results should have same size
assertEqual(size(img), size(r));
assertEqual(size(img), size(g));
assertEqual(size(img), size(b));
