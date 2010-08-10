function test_suite = testCenteredMotionTransform2D(varargin)
%testCenteredMotionTransform2D  One-line description here, please.
%   output = testCenteredMotionTransform2D(input)
%
%   Example
%   testCenteredMotionTransform2D
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

function test_getAffineMatrix


center = [6 8];
T1 = Translation(-center);
rotMat = createRotation(deg2rad(30));
R = MatrixAffineTransform(rotMat);
T2 = Translation(center);

res = T2*R*T1;

T = CenteredMotionTransform2D([30 0 0], 'center', center);

matTh = res.getAffineMatrix();
mat = T.getAffineMatrix();
assertElementsAlmostEqual(matTh, mat);
