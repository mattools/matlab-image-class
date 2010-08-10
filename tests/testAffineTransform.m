function test_suite = testAffineTransform(varargin)
%testAffineTransform  One-line description here, please.
%   output = testAffineTransform(input)
%
%   Example
%   testAffineTransform
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


initTestSuite;

function test_mtimes

% Compose two translations
T1 = Translation([2 3]);
T2 = Translation([4 5]);

res = T1*T2;
mat = res.getAffineMatrix();

matTh = [1 0 6;0 1 8;0 0 1];
assertElementsAlmostEqual(matTh, mat);


center = [6 8];
T1 = Translation(-center);
rotMat = createRotation(deg2rad(30));
R = MatrixAffineTransform(rotMat);
T2 = Translation(center);

res = T2*R*T1;

T = CenteredMotionTransform2D([30 0 0], 'center', center);

assertElementsAlmostEqual(res.getAffineMatrix(), T.getAffineMatrix());
