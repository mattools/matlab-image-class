function test_suite = test_showXYZSlices(varargin)
%TEST_SHOWXYZSLICES  One-line description here, please.
%
%   output = test_showXYZSlices(input)
%
%   Example
%   test_showXYZSlices
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

function testBasic() %#ok<*DEFNU>

img = Image.read('brainMRI.hdr');
figure(1); clf; hold on;
showZSlice(img, 13);
showXSlice(img, 60);
showYSlice(img, 80);
axis(physicalExtent(img));
close(1);