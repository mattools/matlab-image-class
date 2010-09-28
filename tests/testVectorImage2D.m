function test_suite = testVectorImage2D(varargin) %#ok<STOUT>
% Test function for class Image2D
%   output = testImArea(input)
%
%   Example
%   testImEuler2d
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

function testCreateFromArray %#ok<*DEFNU>

dim = [15 10];
dat = zeros([dim(2) dim(1) 4], 'uint8');
img = VectorImage2D(dat);

assertEqual(dim, img.getSize());

% create test image
c1 = [1 2 3 4;5 6 7 8;9 10 11 12];
c2 = [11 12 13 14;15 16 17 18;19 20 21 22];
img = VectorImage2D(cat(3, c1, c2));

% get a pixel
assertEqual([1 11], img.getPixel(1, 1));

% get a pixel not on diagonal
assertEqual([9 19], img.getPixel(1, 3));

% get size
assertEqual([4 3], img.getSize());


% function testCreateFromFile
% 
% img = Image2D.read('cameraman.tif');
% 
% assertElementsAlmostEqual([256 256], img.getSize());
% 
% function testIsa
% 
% img = Image2D(uint8([10 20 30;40 50 60]));
% 
% assertTrue(isa(img, 'Image'));
% assertTrue(isa(img, 'Image2D'));
% 
% 
% function testSum
% 
% img = Image2D(uint8([10 20 30;40 50 60]));
% exp = 210;
% 
% res = sum(img);
% assertEqual([1 1], size(res));
% assertAlmostEqual(exp, res);
% 
% function testMin
% 
% img = Image2D(uint8([10 20 30;40 50 60]));
% exp = uint8(10);
% 
% res = min(img);
% assertEqual([1 1], size(res));
% assertEqual(exp, res);
% 
% % result should have same type as image pixels
% assertTrue(isa(res, 'uint8'));
% 
% function testMax
% 
% img = Image2D(uint8([10 20 30;40 50 60]));
% exp = uint8(60);
% 
% res = max(img);
% assertEqual([1 1], size(res));
% assertEqual(exp, res);
% 
% % result should have same type as image pixels
% assertTrue(isa(res, 'uint8'));
% 
% function testMean
% 
% img = Image2D(uint8([10 20 30;40 50 60]));
% exp = 35;
% 
% res = mean(img);
% assertEqual([1 1], size(res));
% assertAlmostEqual(exp, res);
% 
% 
% function testMedian
% 
% img = Image2D(uint8([10 20 30;40 50 60;70 80 90]));
% exp = 50;
% 
% res = median(img);
% assertEqual([1 1], size(res));
% assertAlmostEqual(exp, res);
% 
% 
% function testVar
% 
% dat = [10 20 30;40 50 60;70 80 90];
% img = Image2D(uint8(dat));
% exp = var(double(dat(:)));
% 
% res = var(img);
% assertEqual([1 1], size(res));
% assertAlmostEqual(exp, res);
% 
% function testStd
% 
% dat = [10 20 30;40 50 60;70 80 90];
% img = Image2D(uint8(dat));
% exp = std(double(dat(:)));
% 
% res = std(img);
% assertEqual([1 1], size(res));
% assertAlmostEqual(exp, res);
% 
% function testFlip
% 
% img = Image2D.read('cameraman.tif');
% 
% img2 = img.flip(1);
% assertElementsAlmostEqual([256 256], img2.getSize());
% 
% 
% img2 = img.flip(2);
% assertElementsAlmostEqual([256 256], img2.getSize());
% 
% 
% function testCrop
% 
% img = Image2D.read('cameraman.tif');
% 
% img2 = img.crop([51 200 51 150]);
% 
% assertElementsAlmostEqual([150 100], img2.getSize());
% 
% 
% 
% 
% function testResample
% 
% img = Image2D.read('cameraman.tif');
% 
% k = 4;
% img2 = img.resample(k);
% expectedSize = img.getSize() * k;
% assertElementsAlmostEqual(expectedSize, img2.getSize());
% 
% k = 3;
% img2 = img.resample(k);
% expectedSize = img.getSize() * k;
% assertElementsAlmostEqual(expectedSize, img2.getSize());
% 
% 
% function testsubsample
% 
% buffer = [...
%     1 2 3 4 5 6; ...
%     2 3 4 5 6 7; ...
%     3 4 5 6 7 8; ...
%     4 5 6 7 8 9];
% img = Image2D(buffer);
% 
% img2 = img.subsample(2);
% assertEqual([3 2], img2.getSize());
% 
% img2 = img.subsample(3);
% assertEqual([2 2], img2.getSize());
% 
% 
% function testBackwardTransform
% 
% img = Image2D.read('cameraman.tif');
% 
% % define identity matrix
% transfo = eye(3);
% 
% img2 = img.backwardTransform(transfo);
% 
% buf1 = img.getBuffer();
% buf2 = img2.getBuffer();
% 
% % remove lower right border that was not evaluated due to rounding effect
% buf1 = buf1(1:end-1, 1:end-1);
% buf2 = buf2(1:end-1, 1:end-1);
% diff = imabsdiff(buf1, buf2);
% 
% assertEqual(0, sum(diff(:)));
% 
% 
% function testBackwardTransformLinearInterpolator
% 
% img = Image2D.read('cameraman.tif');
% 
% % define identity matrix
% transfo = eye(3);
% 
% interp = LinearInterpolator2D(img);
% img2 = img.backwardTransform(transfo, 'interpolator', 'linear');
% 
% buf1 = img.getBuffer();
% buf2 = img2.getBuffer();
% 
% % remove lower right border that was not evaluated due to rounding effect
% buf1 = buf1(1:end-1, 1:end-1);
% buf2 = buf2(1:end-1, 1:end-1);
% diff = imabsdiff(buf1, buf2);
% 
% assertEqual(0, sum(diff(:)));
% 
% function testSetGetSpacing
% 
% img = Image2D.read('cameraman.tif');
% sp = [2.5 3];
% img.setSpacing(sp);
% 
% sp2 = img.getSpacing();
% assertElementsAlmostEqual(sp, sp2);
% 
% function testSetGetOrigin
% 
% img = Image2D.read('cameraman.tif');
% ori = [-5, -10];
% img.setOrigin(ori);
% 
% ori2 = img.getOrigin();
% assertElementsAlmostEqual(ori, ori2);
% 
% function testGetX
% 
% dat = ones(10, 15);
% img = Image2D(dat);
% xImg = img.getX();
% yImg = img.getY();
% [x y] = meshgrid(0:14, 0:9);
% assertElementsAlmostEqual(x, xImg);
% assertElementsAlmostEqual(y, yImg);
% 
% function testShow()
% 
% % test with image full of ones
% dat = ones(10, 15);
% img = Image2D(dat);
% figure(1);
% img.show();
% close(1);
% 
% % test with random uint8 image
% dat = uint8(randi(255, [10 15]));
% img = Image2D(dat);
% figure(1);
% img.show();
% close(1);
% 
% function testSubsref
% 
% lx = 0:1:5;
% ly = 0:10:30;
% [x y] = meshgrid(lx, ly);
% dat = x+y;
% 
% img = Image2D(dat);
% 
% % get one element
% assertEqual(0, img(1));
% assertEqual(1, img(2));
% assertEqual(35, img(end));
% 
% % get one row (y = cte)
% assertEqual(img(:, 2), [10 11 12 13 14 15]);
% 
% % get last row (y = cte)
% assertEqual(img(:, end), [30 31 32 33 34 35]);
% 
% % get one column (x = cte)
% assertEqual(img(2,:), [1 11 21 31]');
% 
% % get last column (x = cte)
% assertEqual(img(end,:), [5 15 25 35]');
% 
% 
% function testSubsasgn
% 
% lx = 0:1:5;
% ly = 0:10:30;
% [x y] = meshgrid(lx, ly);
% dat = x+y;
% img = Image2D(dat);
% 
% % set one element
% img(1) = 99;
% assertEqual(99, img(1));
% img(2) = 99;
% assertEqual(99, img(2));
% img(end) = 99;
% assertEqual(99, img(end));
% 
% % get one row (y = cte)
% new = 8:2:18;
% img(:,2) = new;
% assertEqual(new, img(:, 2));
% 
% % get last row (y = cte)
% img(:,end) = new;
% assertEqual(new, img(:, end));
% 
% % get one column (x = cte)
% new = (12:3:21)';
% img(1,:) = new;
% assertEqual(new, img(1,:));
% 
% % get last column (x = cte)
% img(end,:) = new;
% assertEqual(new, img(end,:));
% 
