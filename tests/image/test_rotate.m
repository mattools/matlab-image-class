function tests = test_rotate
% Test suite for the file rotate.
%
%   Test suite for the file rotate
%
%   Example
%   test_rotate
%
%   See also
%     rotate

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-07,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.


img = Image.read('rice.png');

res = rotate(img, 10);

assertTrue(testCase, isa(res, 'Image'));


function test_OptionCrop(testCase) %#ok<*DEFNU>
% Test call of function without argument.


img = Image.read('rice.png');

res = rotate(img, 10, 'crop');

assertTrue(testCase, isa(res, 'Image'));
assertEqual(testCase, size(res), size(img));
