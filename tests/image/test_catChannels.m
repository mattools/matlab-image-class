function test_suite = test_catChannels(varargin) %#ok<STOUT>
%TEST_CATCHANNELS  Test case for the file catChannels
%
%   Test case for the file catChannels

%   Example
%   test_catChannels
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

initTestSuite;

function test_Simple %#ok<*DEFNU>
% Test call of function without argument
img = Image.read('cameraman.tif');
res = catChannels(img, img, invert(img));
assertEqual(3, channelNumber(res));

assertEqual(size(img), size(res));
