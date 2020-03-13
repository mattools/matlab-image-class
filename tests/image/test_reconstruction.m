function tests = test_reconstruction(varargin)
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

tests = functiontests(localfunctions);

function test_Binary(testCase) %#ok<*DEFNU>
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
    
res = reconstruction(marker, mask);

assertEqual(testCase, 0, sum(res ~= mask));

