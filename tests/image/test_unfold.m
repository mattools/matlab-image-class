function tests = test_unfold(varargin)
%TEST_NUMEL  One-line description here, please.
%
%   output = test_unfold(input)
%
%   Example
%   test_unfold
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_2d_color(testCase)

img = Image.read('peppers.png');
nr = elementNumber(img);
nc = channelNumber(img);

tab = unfold(img);
assertEqual(testCase, size(tab), [nr nc]);

function test_2d_color_getNames(testCase)

img = Image.read('peppers.png');

[tab, names] = unfold(img);
assertTrue(testCase, iscell(names));
assertEqual(testCase, length(names), size(tab, 2));

