function tests = test_channelCount(varargin)
%TEST_CHANNELNUMBER  One-line description here, please.
%
%   output = test_channelCount(input)
%
%   Example
%   test_channelCount
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-07-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_2d(testCase) %#ok<*DEFNU>

img = Image.read('peppers.png');
nc = channelCount(img);

assertEqual(testCase, 3, nc);

