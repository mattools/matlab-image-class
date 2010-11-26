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


function test_crop

img = Image.read('cameraman.tif');

img2 = img.crop([51 200 51 150]);

assertElementsAlmostEqual([150 100], img2.getSize());


function test_resample

img = Image.read('cameraman.tif');

k = 4;
img2 = img.resample(k);
expectedSize = img.getSize() * k;
assertElementsAlmostEqual(expectedSize, img2.getSize());

k = 3;
img2 = img.resample(k);
expectedSize = img.getSize() * k;
assertElementsAlmostEqual(expectedSize, img2.getSize());


function test_subsample

buffer = [...
    1 2 3 4 5 6; ...
    2 3 4 5 6 7; ...
    3 4 5 6 7 8; ...
    4 5 6 7 8 9];
img = Image.create(buffer);

img2 = img.subsample(2);
assertEqual([3 2], img2.getSize());

img2 = img.subsample(3);
assertEqual([2 2], img2.getSize());

