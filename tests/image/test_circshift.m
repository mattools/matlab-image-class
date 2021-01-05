function tests = test_circshift
% Test suite for the file circshift.
%
%   Test suite for the file circshift
%
%   Example
%   test_circshift
%
%   See also
%     circshift

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-05,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = Image.create(10 * ones(10, 10));

res = circshift(img, [3 2]);

assertTrue(testCase, isa(res, 'Image'));


