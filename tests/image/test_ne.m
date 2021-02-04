function tests = test_ne
% Test suite for the file ne.
%
%   Test suite for the file ne
%
%   Example
%   test_ne
%
%   See also
%     ne

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-02-04,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

lx = 1:6;
ly = 10:10:40;
[x, y]= meshgrid(lx, ly);
img = Image(x + y);

bin = img ~= 23;

assertTrue(testCase, isa(bin, 'Image'));
assertEqual(testCase, bin.Type, 'binary');
assertEqual(testCase, size(bin), size(img));

assertTrue(testCase,  bin(1, 1));
assertFalse(testCase, bin(3, 2));
assertTrue(testCase,  bin(6, 4));
