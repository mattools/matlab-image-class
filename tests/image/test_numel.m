function tests = test_numel(varargin)
%TEST_NUMEL  One-line description here, please.
%
%   output = test_numel(input)
%
%   Example
%   test_numel
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_2d_gray(testCase) %#ok<*DEFNU>

% img = Image.read('cameraman.tif');
% exp = 256 * 256;
% n = numel(img);
% assertEqual(exp, n);


function test_2d_color(testCase)

% img = Image.read('peppers.png');
% s1 = size(img, 1);
% s2 = size(img, 2);
% assertEqual(s1*s2, numel(img));


