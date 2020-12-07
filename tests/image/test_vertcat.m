function tests = test_vertcat
% Test suite for the file vertcat.
%
%   Test suite for the file vertcat
%
%   Example
%   test_vertcat
%
%   See also
%     vertcat

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

res = vertcat(img, img);

assertTrue(testCase, isa(res, 'Image'));
assertEqual(testCase, size(res), [30 40]);

