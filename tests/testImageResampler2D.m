function test_suite = testImageResampler2D(varargin)
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

function testSimple

img = Image2D.create(imread('cameraman.tif'));

res = ImageResampler2D(1:300, 1:300);
img2 = res.resample(img, 'linear');
assertEqual([300 300], img2.getSize());

lin = .5:.5:300;
res = ImageResampler2D(lin, lin);
img2 = res.resample(img, 'linear');
assertEqual([600 600], img2.getSize());
assertEqual([.5 .5], img2.getOrigin());
assertEqual([.5 .5], img2.getSpacing());
