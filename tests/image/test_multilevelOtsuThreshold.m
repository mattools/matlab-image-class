function tests = test_multilevelOtsuThreshold
% Test suite for the file multilevelOtsuThreshold.
%
%   Test suite for the file multilevelOtsuThreshold
%
%   Example
%   test_multilevelOtsuThreshold
%
%   See also
%     multilevelOtsuThreshold

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-02-02,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = Image.read('cameraman.tif');

classes = multilevelOtsuThreshold(img, 3);

assertEqual(testCase, size(classes), size(img));


function test_getLevels(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = Image.read('cameraman.tif');

[classes, levels] = multilevelOtsuThreshold(img, 3);

assertEqual(testCase, size(classes), size(img));
assertEqual(testCase, length(levels), 2);
