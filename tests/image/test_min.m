function test_suite = test_min(varargin)
%TEST_MIN  One-line description here, please.
%
%   output = test_min(input)
%
%   Example
%   test_min
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_2d %#ok<*DEFNU>

img = Image.create(uint8([10 20 30;40 50 60]));
exp = uint8(10);

res = min(img);
assertEqual([1 1], size(res));
assertEqual(exp, res);

% result should have same type as image pixels
assertTrue(isa(res, 'uint8'));


function test_2d_color 

img = Image.read('peppers.png');

res = min(img);
assertEqual([1 3], size(res));


function test_2d_color_2

img = Image.read('peppers.png');

res = min(img, 50);
assertTrue(isa(res, 'Image'));

assertEqual([50 50 50], max(res));



function test_3d

dat = uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]));
img = Image.create(dat);
exp = uint8(10);

res = min(img);
assertEqual([1 1], size(res));
assertEqual(exp, res);

% result should have same type as image pixels
assertTrue(isa(res, 'uint8'));


