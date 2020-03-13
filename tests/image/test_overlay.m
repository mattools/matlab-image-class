function tests = test_overlay(varargin)
%TEST_OVERLAY  Test case for the file overlay
%
%   Test case for the file overlay

%   Example
%   test_overlay
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-01-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_Circles(testCase) %#ok<*DEFNU>
% test overlay on a simple binary image

img = Image.read('circles.png');

bnd = boundary(img);
ovr = overlay(img, bnd);

assertTrue(testCase, isColorImage(ovr));
assertEqual(testCase, size(ovr), size(img));

function test_multipleOverlay(testCase)
img = Image.read('coins.png');
bin = closing(img>100, ones(3, 3));
bnd = boundary(bin);
wat = watershed(distanceMap(bin), 8);

% compute and display overlay as 3 separate bands
ovr = overlay(img, bnd, [], wat==0);
assertTrue(testCase, isColorImage(ovr));
assertEqual(testCase, size(ovr), size(img));


% display result with different colors
ovr = overlay(img, bnd, 'y', wat==0, [1 0 1]);
assertTrue(testCase, isColorImage(ovr));
assertEqual(testCase, size(ovr), size(img));


function test_brainMRI(testCase)
% Compute overlay on a 3D image

img = Image.read('brainMRI.hdr'); % read 3D data
se = ones([3 3 3]);
bin = closing(img > 0, se);       % binarize and remove small holes
bnd = boundary(bin);              % compute boundary
ovr = overlay(img*3, bnd, 'm');   % compute overlay

assertTrue(testCase, isColorImage(ovr));
assertEqual(testCase, size(ovr), size(img));


function test_doubleImage(testCase)

img = Image.read('cameraman.tif');
gn = norm(gradient(img));
bin = gn > 50;

ovr = overlay(gn, bin);

assertTrue(testCase, isColorImage(ovr));
assertEqual(testCase, size(ovr), size(img));

[r, g, b] = splitChannels(ovr); %#ok<ASGLU>
assertTrue(testCase, sum(g > 128) < prod(size(img)) / 2) %#ok<PSIZE>

function test_OverlayImage(testCase)

% read input grayscale image
img = Image.read('cameraman.tif');
img = Image(img(:, 1:end-50));

% create a colorized version of the image (yellow = red + green)
yellow = Image.createRGB(img, img, []);
% compute binary a mask around the head of the cameraman
mask = Image.create(size(img), 'binary');
mask(80:180, 20:120) = true;
% compute and show the overlay
ovr = overlay(img, mask, yellow);

assertTrue(testCase, isColorImage(ovr));
assertEqual(testCase, size(ovr), size(img));
