function tests = test_histogram(varargin)
%TEST_histogram  One-line description here, please.
%
%   output = test_histogram(input)
%
%   Example
%   test_histogram
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-09-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_cameraman(testCase) %#ok<*DEFNU>

img = Image.read('cameraman.tif');
h = histogram(img);

assertEqual(testCase, 256, length(h));
assertEqual(testCase, elementCount(img), sum(h));


function test_cameraman_nbins(testCase)

img = Image.read('cameraman.tif');
h0 = histogram(img);
h = histogram(img, 256);
assertEqual(testCase, h0, h);


function test_cameraman_xlims(testCase)

img = Image.read('cameraman.tif');
h0 = histogram(img);
h = histogram(img, [0 255]);
assertEqual(testCase, h0, h);

function test_cameraman_xbins(testCase)

img = Image.read('cameraman.tif');
h0 = histogram(img);
h = histogram(img, linspace(0, 255, 256));
assertEqual(testCase, h0, h);


function test_cameraman_display(testCase)

img = Image.read('cameraman.tif');
figure;
histogram(img);
close;


function test_cameraman_float(testCase)

img = Image.read('cameraman.tif');
h0 = histogram(img);

buffer = getBuffer(img);
buffer = double(buffer)/255;
img2 = Image.create(buffer);
h = histogram(img2, [0 1]);

assertEqual(testCase, elementCount(img2), sum(h));
assertEqual(testCase, h0, h);


function test_cameraman_roi(testCase)

img = Image.read('cameraman.tif');
mask = img < 80;
h1 = histogram(img, mask);
h2 = histogram(img, ~mask);

assertEqual(testCase, 256, length(h1));
assertEqual(testCase, 256, length(h2));
assertEqual(testCase, elementCount(img), sum(h1)+sum(h2));


function test_peppers(testCase)

img = Image.read('peppers.png');
h = histogram(img);

assertEqual(testCase, [256 3], size(h));
assertEqual(testCase, elementCount(img), sum(h(:,1)));


function test_peppers_display(testCase)

img = Image.read('peppers.png');
figure;
histogram(img);
close;


% % Disabled until there is proper color conversion function
% function test_peppers_roi
% 
% img = Image.read('peppers.png');
% hsv = rgb2hsv(img);
% mask = hsv(:,:,1)<.7 | hsv(:,:,1)>.9;
% 
% h1 = histogram(img, mask);
% h2 = histogram(img, ~mask);
% 
% assertEqual(256, size(h1, 1));
% assertEqual(256, size(h2, 1));
% assertEqual(elementCount(img), sum(h1(:))+sum(h2(:)));


function test_brainMRI(testCase)

X = Image.read('brainMRI.hdr');
h = histogram(X);
assertEqual(testCase, elementCount(X), sum(h(:)));

function test_brainMRI_roi_bins(testCase)

X = Image.read('brainMRI.hdr');
h = histogram(X, X>0, 1:88);

assertEqual(testCase, 88, length(h));

