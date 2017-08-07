function test_suite = test_invert(varargin)
%TEST_INVERT  One-line description here, please.
%
%   output = test_invert(input)
%
%   Example
%   test_invert
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-12,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_cameraman %#ok<*DEFNU>

img = Image.read('cameraman.tif');
inv = invert(img);

assertEqual(size(img), size(inv));

function test_peppers

img = Image.read('peppers.png');
inv = invert(img);

assertEqual(size(img), size(inv));



