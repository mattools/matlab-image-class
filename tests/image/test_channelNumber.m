function tests = test_channelNumber(varargin)
%TEST_CHANNELNUMBER  One-line description here, please.
%
%   output = test_channelNumber(input)
%
%   Example
%   test_channelNumber
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-07-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_2d(testCase) %#ok<*DEFNU>

img = Image.read('peppers.png');
nc = channelNumber(img);

assertEqual(testCase, 3, nc);

