function test_suite = test_calibration(varargin) %#ok<STOUT>
%TEST_CALIBRATION  One-line description here, please.
%
%   output = test_calibration(input)
%
%   Example
%   test_calibration
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


function test_setGetSpacing %#ok<*DEFNU>

img = Image.read('cameraman.tif');
sp = [2.5 3];
img.setSpacing(sp);

sp2 = img.getSpacing();
assertElementsAlmostEqual(sp, sp2);


function test_setGetOrigin

img = Image.read('cameraman.tif');
ori = [-5, -10];
img.setOrigin(ori);

ori2 = img.getOrigin();
assertElementsAlmostEqual(ori, ori2);


function test_setGetSpacing3d

dat = cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]);
img = Image.create(uint8(dat));
sp = [2.5 3 1.5];
img.setSpacing(sp);

sp2 = img.getSpacing();
assertElementsAlmostEqual(sp, sp2);

function test_setGetOrigin3d

dat = cat(3, [10 20 30;40 50 60], [30 40 50;60 70 80]);
img = Image.create(uint8(dat));

ori = [-5 -10 -2];
img.setOrigin(ori);

ori2 = img.getOrigin();
assertElementsAlmostEqual(ori, ori2);
