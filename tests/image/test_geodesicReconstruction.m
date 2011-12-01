function test_suite = test_geodesicReconstruction(varargin) %#ok<STOUT>
%TEST_GEODESICRECONSTRUCTION  Test case for the file geodesicReconstruction
%
%   Test case for the file geodesicReconstruction

%   Example
%   test_geodesicReconstruction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

initTestSuite;

function test_Binary %#ok<*DEFNU>
% Test call of function without argument

maskData = [ ...
    0 0 0 0 0 0 0; ...
    0 1 1 1 0 1 0; ...
    0 1 0 1 0 1 0; ...
    0 1 0 1 1 1 0; ...
    0 0 0 0 0 0 0] > 0;
mask = Image.create(maskData);

markerData = false(size(maskData));
markerData(2, 2) = true;
marker = Image.create(markerData);
    

res = geodesicReconstruction(marker, mask);

assertEqual(0, sum(res ~= mask));

