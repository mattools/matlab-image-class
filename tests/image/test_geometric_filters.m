function test_suite = test_geometric_filters(varargin) %#ok<STOUT>
%TEST_GEOMETRIC_FILTERS Test some geometric filters like flip, rotate...
%
%   output = test_geometric_filters(input)
%
%   Example
%   test_geometric_filters
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

initTestSuite;


function test_crop %#ok<*DEFNU>

img = Image.read('cameraman.tif');

img2 = img.crop([51 200 51 150]);

assertElementsAlmostEqual([150 100], size(img2));


function test_subsample

buffer = [...
    1 2 3 4 5 6; ...
    2 3 4 5 6 7; ...
    3 4 5 6 7 8; ...
    4 5 6 7 8 9];
img = Image.create(buffer);

img2 = img.subsample(2);
assertEqual([3 2], size(img2));

img2 = img.subsample(3);
assertEqual([2 2], size(img2));

