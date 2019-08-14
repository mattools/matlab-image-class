function test_suite = test_minus(varargin)
%TEST_MINUS  Test case for the file minus
%
%   Test case for the file minus

%   Example
%   test_minus
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-08-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_TwoImages %#ok<*DEFNU>

img1 = Image.create([1 2 3 4;5 6 7 8;9 10 11 12]);
img2 = Image.create(ones(3, 4));

exp = Image.create([0 1 2 3;4 5 6 7; 8 9 10 11]);
res = img1 - img2;
assertElementsAlmostEqual(exp.Data, res.Data);

function test_Constant 

img1 = Image.create([3 4 5 6; 7 8 9 10; 11 12 13 14]);

exp = Image.create([1 2 3 4;5 6 7 8;9 10 11 12]);


res = img1 - 2;
assertElementsAlmostEqual(exp.Data, res.Data);

res = 2 - img1;
exp = exp * (-1);
assertElementsAlmostEqual(exp.Data, res.Data);



