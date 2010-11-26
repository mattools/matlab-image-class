function test_suite = test_histogram(varargin) %#ok<STOUT>
%TEST_histogram  One-line description here, please.
%
%   output = test_histogram(input)
%
%   Example
%   test_histogram
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-09-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

initTestSuite;

function test_cameraman %#ok<*DEFNU>

img = Image.read('cameraman.tif');
h = histogram(img);

assertEqual(256, length(h));
assertEqual(getElementNumber(img), sum(h));


function test_cameraman_nbins

img = Image.read('cameraman.tif');
h0 = histogram(img);
h = histogram(img, 256);
assertEqual(h0, h);


function test_cameraman_xlims 

img = Image.read('cameraman.tif');
h0 = histogram(img);
h = histogram(img, [0 255]);
assertEqual(h0, h);

function test_cameraman_xbins 

img = Image.read('cameraman.tif');
h0 = histogram(img);
h = histogram(img, linspace(0, 255, 256));
assertEqual(h0, h);


function test_cameraman_display

img = Image.read('cameraman.tif');
figure;
histogram(img);
close;


function test_cameraman_float

img = Image.read('cameraman.tif');
h0 = histogram(img);

buffer = getBuffer(img);
buffer = double(buffer)/255;
img2 = Image.create(buffer);
h = histogram(img2, [0 1]);

assertEqual(getElementNumber(img2), sum(h));
assertEqual(h0, h);


function test_cameraman_roi

img = Image.read('cameraman.tif');
mask = img<80;
h1 = histogram(img, mask);
h2 = histogram(img, ~mask);

assertEqual(256, length(h1));
assertEqual(256, length(h2));
assertEqual(getElementNumber(img), sum(h1)+sum(h2));


function test_peppers

img = Image.read('peppers.png');
h = histogram(img);

assertEqual([256 3], size(h));
assertEqual(getElementNumber(img), sum(h(:)));


function test_peppers_display %#ok<*DEFNU>

img = Image.read('peppers.png');
figure;
histogram(img);
close;


function test_peppers_roi

img = Image.read('peppers.png');
hsv = rgb2hsv(img);
mask = hsv(:,:,1)<.7 | hsv(:,:,1)>.9;

h1 = histogram(img, mask);
h2 = histogram(img, ~mask);

assertEqual(256, size(h1, 1));
assertEqual(256, size(h2, 1));
assertEqual(getElementNumber(img), sum(h1(:))+sum(h2(:)));


function test_brainMRI

X = Image.read('brainMRI.hdr');
h = histogram(X);
assertEqual(getElementNumber(X), sum(h(:)));

function test_brainMRI_roi_bins

X = Image.read('brainMRI.hdr');
h = histogram(X, X>0, 1:88);

assertEqual(88, length(h));

