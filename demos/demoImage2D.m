%TESTIMAGE2D  One-line description here, please.
%   output = testImage2D(input)
%
%   Example
%   testImage2D
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-04-20,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.
% Licensed under the terms of the LGPL, see the file "license.txt"

% clean up
clear all;
clear classes;

% create test image
dat = [1 2 3 4;5 6 7 8;9 10 11 12];
img = Image2D(dat);

% get a pixel
assertEqual(11, img.getPixel(2, 2));

% get a pixel not on diagonal
assertEqual(9, img.getPixel(0, 2));

% get size
assertElementsAlmostEqual([4 3], img.getSize());

