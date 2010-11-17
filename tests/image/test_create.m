function test_suite = test_create(varargin) %#ok<STOUT>
%TEST_CREATE  One-line description here, please.
%
%   output = test_create(input)
%
%   Example
%   test_create
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


function test_createFromArray %#ok<*DEFNU>

% empty image
dim = [15 10];
dat = zeros([dim(2) dim(1)], 'uint8');
img = Image.create(dat);

assertElementsAlmostEqual(dim, img.getSize());

% create non-empty test image
dat = [1 2 3 4;5 6 7 8;9 10 11 12];
img = Image.create(dat);

% get size
assertElementsAlmostEqual([4 3], img.getSize());


function test_createFromArray3D
% create Image from array, then make some tests on size and getPixel

dim = [10 15 20];
dat = zeros(dim([2 1 3]), 'uint8');
img = Image.create(dat);

assertEqual(dim, img.getSize());

dat = uint8(cat(3, ...
    [1 2 3 4;5 6 7 8;9 10 11 12], ...
    [2 3 4 5;6 7 8 9;10 11 12 13]));
img = Image.create(dat);
dim = [4 3 2];
assertEqual(dim, img.getSize());

% get a pixel
assertEqual(uint8(7), img.getPixel(2, 2, 2));

% get a pixel not on diagonal
assertEqual(uint8(10), img.getPixel(2, 3, 1));

