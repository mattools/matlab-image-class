function test_suite = testBackwardTransformedImage(varargin) %#ok<STOUT>
%TESTBACKWARDTRANSFORMEDIMAGE  One-line description here, please.
%   output = testBackwardTransformedImage(input)
%
%   Example
%   testBackwardTransformedImage
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-04-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

initTestSuite;

function testCreationImageTransform %#ok<*DEFNU>

img = Image.read('cameraman.tif');
trans = TranslationModel([50 20]);

tim = BackwardTransformedImage(img, trans);

function testCreationInterpTransform

img = Image.read('cameraman.tif');
interp = LinearInterpolator2D(img);
trans = TranslationModel([50 20]);

tim = BackwardTransformedImage(interp, trans);
