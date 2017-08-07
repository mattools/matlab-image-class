function test_suite = test_showOrthoPlanes(varargin)
%TEST_SHOWORTHOPLANES  One-line description here, please.
%
%   output = test_showOrthoPlanes(input)
%
%   Example
%   test_showOrthoPlanes
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-07-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_brain %#ok<*DEFNU>

img = Image.read('brainMRI.hdr');
figure(1); clf; hold on;
showOrthoPlanes(img, [60 80 13]);
axis(physicalExtent(img));       % setup axis limits
axis equal;
close(1);
