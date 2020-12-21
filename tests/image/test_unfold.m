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

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-06-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_2d_color(testCase)

img = Image.read('peppers.png');
nr = elementCount(img);
nc = channelCount(img);

tab = unfold(img);

assertTrue(testCase, isa(tab, 'Table'));
assertEqual(testCase, size(tab), [nr nc]);


function test_2d_color_getNames(testCase)

img = Image.read('peppers.png');

[tab, coords] = unfold(img);

assertTrue(testCase, isa(coords, 'Table'));
assertEqual(testCase, size(tab, 1), prod(size(img))); %#ok<PSIZE>
ax2 = coords.Axes{2};
assertEqual(testCase, length(ax2.Names), ndims(img));
