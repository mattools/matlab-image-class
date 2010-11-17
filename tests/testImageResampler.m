function test_suite = testImageResampler(varargin) %#ok<STOUT>
% Test function for class ImageResampler2D
%   output = testImageResampler()
%
%   Example
%   
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-04-22,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.
% Licensed under the terms of the LGPL, see the file "license.txt"

initTestSuite;

function testResampler2D %#ok<*DEFNU>

img = Image.read('cameraman.tif');

res = ImageResampler(1:300, 1:300);
img2 = res.resample(img, 'linear');
assertEqual([300 300], img2.getSize());

lin = .5:.5:300;
res = ImageResampler(lin, lin);
img2 = res.resample(img, 'linear');
assertEqual([600 600], img2.getSize());
assertEqual([.5 .5], img2.getOrigin());
assertEqual([.5 .5], img2.getSpacing());



function testResampler3D

% create test image
dat = zeros([20 20 20], 'uint8');
dat(5:15, 5:15, 5:15) = 255;
img = Image.create(dat);

% setup resampler
lx = linspace(0, 19, 20);
ly = linspace(0, 19, 30);
lz = linspace(0, 19, 40);
res = ImageResampler(lx, ly, lz);

% compute resampled image
img2 = res.resample(img, 'linear');
assertEqual([20 30 40], img2.getSize());
