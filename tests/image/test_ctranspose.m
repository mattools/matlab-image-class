function tests = test_ctranspose(varargin)
%TEST_CTRANSPOSE  One-line description here, please.
%
%   output = test_ctranspose(input)
%
%   Example
%   test_ctranspose
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_grayscale(testCase) %#ok<*DEFNU>

img = Image.read('cameraman.tif');
dim = size(img);
img2 = img'; 
dim2 = size(img2);
assertEqual(testCase, dim, dim2([2 1]));

function test_color(testCase)

img = Image.read('peppers.png');
dim = size(img);
img2 = img'; 
dim2 = size(img2);
assertEqual(testCase, dim, dim2([2 1]));
