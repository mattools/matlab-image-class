function test_suite = test_ismember(varargin)
%TEST_ISMEMBER  Test case for the file ismember
%
%   Test case for the file ismember

%   Example
%   test_ismember
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_Simple %#ok<*DEFNU>

dat = [1 2 3 4;5 6 7 8;9 10 11 12];

img = Image.create(dat);   

exp = Image.create([1 1 1 0;0 0 1 1;1 0 0 0]);

labels = [1 2 3 7 8 9];
res = ismember(img, labels);

assertTrue(isa(res, 'Image'));

comp = res ~= exp;
assertEqual(0, sum(comp));
