function tests = test_catChannels(varargin) 
%TEST_CATCHANNELS  Test case for the file catChannels
%
%   Test case for the file catChannels
%
%   Example
%   test_catChannels
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-11-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument

img = Image.read('cameraman.tif');

res = catChannels(img, img, invert(img));

assertEqual(3, channelCount(res));
assertEqual(testCase, size(img), size(res));
