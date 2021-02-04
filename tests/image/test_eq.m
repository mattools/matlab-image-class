function tests = test_eq
% Test suite for the file eq.
%
%   Test suite for the file eq
%
%   Example
%   test_eq
%
%   See also
%     eq

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

bin = img == 23;

assertTrue(testCase, isa(bin, 'Image'));
assertEqual(testCase, bin.Type, 'binary');
assertEqual(testCase, size(bin), size(img));

assertFalse(testCase, bin(1, 1));
assertTrue(testCase,  bin(3, 2));
assertFalse(testCase, bin(6, 4));
