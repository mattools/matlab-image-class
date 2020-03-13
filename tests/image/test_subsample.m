function tests = test_subsample(varargin)
%TEST_SUBSAMPLE Test file for subsample function
%
%   output = test_subsample(input)
%
%   Example
%   test_subsample
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_2d(testCase)  %#ok<*DEFNU>

buffer = [...
    1 2 3 4 5 6; ...
    2 3 4 5 6 7; ...
    3 4 5 6 7 8; ...
    4 5 6 7 8 9];
img = Image.create(buffer);

img2 = subsample(img, 2);
assertEqual(testCase, [3 2], size(img2));

img2 = subsample(img, 3);
assertEqual(testCase, [2 2], size(img2));

