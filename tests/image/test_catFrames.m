function test_suite = test_catFrames(varargin) 
%test_catFrames  Test case for the file catChannels
%
%   Test case for the file catChannels

%   Example
%   test_catFrames
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_Simple %#ok<*DEFNU>
% Test call of function without argument
img = Image.read('cameraman.tif');
res = catFrames(img, img, invert(img), invert(img), img);
assertEqual(5, frameNumber(res));

assertEqual(size(img), size(res, 1:2));
