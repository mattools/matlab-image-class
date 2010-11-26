function test_suite = test_mean(varargin) %#ok<STOUT>
%TEST_MEAN  One-line description here, please.
%
%   output = test_mean(input)
%
%   Example
%   test_mean
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

function test_2d %#ok<*DEFNU>

img = Image.create(uint8([10 20 30;40 50 60]));
exp = 35;

res = mean(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);

function test_3d

dat = uint8(cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]));
img = Image.create(dat);
exp = 45;

res = mean(img);
assertEqual([1 1], size(res));
assertAlmostEqual(exp, res);


