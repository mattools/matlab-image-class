function tests = test_createNewName
% Test suite for the file createNewName.
%
%   Test suite for the file createNewName
%
%   Example
%   test_createNewName
%
%   See also
%     createNewName

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-05,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_NoName(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = Image(false(10, 10));
inv = invert(img);

assertTrue(testCase, isempty(inv.Name));


function test_WithName(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = Image(false(10, 10));
img.Name = 'base';
inv = invert(img);

assertFalse(testCase, isempty(inv.Name));
