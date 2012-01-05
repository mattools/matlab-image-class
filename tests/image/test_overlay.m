function test_suite = test_overlay(varargin) %#ok<STOUT>
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

initTestSuite;

function test_Circles %#ok<*DEFNU>
% test overlay on a simple binary image

img = Image.read('circles.png');

bnd = boundary(img);
ovr = overlay(img, bnd);

assertTrue(isColorImage(ovr));
assertEqual(size(ovr), size(img));


function test_brainMRI
% Compute overlay on a 3D image

img = Image.read('brainMRI.hdr'); % read 3D data
se = ones([3 3 3]);
bin = closing(img > 0, se);       % binarize and remove small holes
bnd = boundary(bin);              % compute boundary
ovr = overlay(img*3, bnd, 'm');   % compute overlay

assertTrue(isColorImage(ovr));
assertEqual(size(ovr), size(img));


function test_doubleImage

img = Image.read('cameraman.tif');
gn = norm(gradient(img));
bin = gn > 50;

ovr = overlay(gn, bin);

assertTrue(isColorImage(ovr));
assertEqual(size(ovr), size(img));

[r g b] = splitChannels(ovr); %#ok<ASGLU,NASGU>
assertTrue(sum(g > 128) < prod(size(img)) / 2) %#ok<PSIZE>

