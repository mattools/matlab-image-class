function tests = test_double2rgb
% Test suite for the file double2rgb.
%
%   Test suite for the file double2rgb
%
%   Example
%   test_double2rgb
%
%   See also
%     double2rgb

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-05,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = Image.true([15 15]);
img(8, 8) = 0;
dist = distanceMap(img);

rgb = double2rgb(dist, 'parula', [], 'w');

assertTrue(testCase, isa(rgb, 'Image'));


