function tests = test_componentLabeling
%TEST_COMPONENTLABELING  Test case for the file componentLabeling
%
%   Test case for the file componentLabeling
%
%   Example
%   test_componentLabeling
%
%   See also
%   componentLabeling

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-08-22,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_processCoins(testCase) %#ok<*DEFNU>

img = Image.read('coins.png');
bin = opening(img > 80, ones(3, 3));
lbl = componentLabeling(bin);
labelNumber = max(lbl);

assertEqual(testCase, 10, labelNumber);
