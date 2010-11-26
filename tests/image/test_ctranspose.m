function test_suite = test_ctranspose(varargin) %#ok<STOUT>
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

initTestSuite;

function test_grayscale %#ok<*DEFNU>

img = Image.read('cameraman.tif');
dim = img.getSize();
img2 = img'; 
dim2 = img2.getSize();
assertEqual(dim, dim2([2 1]));

function test_color

img = Image.read('peppers.png');
dim = img.getSize();
img2 = img'; 
dim2 = img2.getSize();
assertEqual(dim, dim2([2 1]));
