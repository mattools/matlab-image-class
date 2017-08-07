function test_suite = test_clearBorders(varargin)
%TEST_CLEARBORDERS  Test case for the file clearBorders
%
%   Test case for the file clearBorders

%   Example
%   test_clearBorders
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_Simple %#ok<*DEFNU>
% Test call of function without argument

dat = [...
    1 1 0 0 0 0 ;...
    1 0 1 0 1 0 ;...
    0 0 0 0 1 0 ;...
    0 1 0 0 0 1 ;...
    0 0 0 1 0 0] > 0;
img = Image.create(dat);

exp4 = Image.create([...
    0 0 0 0 0 0 ;...
    0 0 1 0 1 0 ;...
    0 0 0 0 1 0 ;...
    0 1 0 0 0 0 ;...
    0 0 0 0 0 0]>0);

res = clearBorders(img);

assertTrue(sum(res ~= exp4) == 0);

exp8 = Image.create([...
    0 0 0 0 0 0 ;...
    0 0 0 0 0 0 ;...
    0 0 0 0 0 0 ;...
    0 1 0 0 0 0 ;...
    0 0 0 0 0 0]>0);

res = clearBorders(img, 8);

assertTrue(sum(res ~= exp8) == 0);
