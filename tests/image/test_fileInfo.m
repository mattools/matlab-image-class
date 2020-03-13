function tests = test_fileInfo
%TEST_FILEINFO  Test case for the file fileInfo
%
%   Test case for the file fileInfo
%
%   Example
%   test_fileInfo
%
%   See also
%   fileInfo

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-08-22,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_tif(testCase) %#ok<*DEFNU>
% Test call of function without argument
info = Image.fileInfo('cameraman.tif');
assertFalse(testCase, isempty(info));

function test_mhd(testCase) %#ok<*DEFNU>
% Test call of function without argument
info = Image.fileInfo('files/ellipsoidGray.mhd');
assertFalse(testCase, isempty(info));


