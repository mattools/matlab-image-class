function tests = test_horzcat
% Test suite for the file horzcat.
%
%   Test suite for the file horzcat
%
%   Example
%   test_horzcat
%
%   See also
%     horzcat

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-07,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = 200 * ones([20 30], 'uint8');
img = Image(data);

res = horzcat(img, img);

assertTrue(testCase, isa(res, 'Image'));
assertEqual(testCase, size(res), [60 20]);

