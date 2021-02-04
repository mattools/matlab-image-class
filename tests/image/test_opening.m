function tests = test_opening
% Test suite for the file opening.
%
%   Test suite for the file opening
%
%   Example
%   test_opening
%
%   See also
%     opening

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-02-04,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = zeros([16 14], 'uint8');
data(2:4, 2:4) = 150;
data(2:4, 8:13) = 150;
data(8:15, 8:13) = 150;
img = Image('Data', data);

% apply opening making two smallest regions disappear
res = opening(img, ones(5,5));

assertEqual(testCase, size(res), size(img));
assertTrue(testCase, isa(res, 'Image'));
assertEqual(testCase, res.Type, img.Type);

assertEqual(testCase, double(res( 3, 3)), 0);
assertEqual(testCase, double(res(10, 3)), 0);
assertEqual(testCase, double(res(10, 10)), 150);
