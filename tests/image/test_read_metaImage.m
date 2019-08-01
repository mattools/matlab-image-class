function test_suite = test_read_metaImage(varargin) 
%TEST_READ  One-line description here, please.
%
%   output = test_read(input)
%
%   Example
%   test_read
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_read_ellipsoid_gray %#ok<*DEFNU>

img = Image.read(fullfile('files', 'ellipsoidGray.mhd'));

assertEqual([40 30 20], size(img));



