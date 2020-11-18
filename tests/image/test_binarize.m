function tests = test_binarize
% Test suite for the file binarize.
%
%   Test suite for the file binarize
%
%   Example
%   test_binarize
%
%   See also
%     binarize

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-11-18,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = magic(5);
img = Image(data);

bin = binarize(img);

assertTrue(testCase, isa(bin, 'Image'));
assertTrue(testCase, isBinaryImage(bin));

