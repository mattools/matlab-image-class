function test_suite = testTransform(varargin)
%testTransform  One-line description here, please.
%   output = testTransform(input)
%
%   Example
%   testTransform
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

function test_compose

% transform parameters
center = [6 8];
angle = deg2rad(30);


% create transform objects
T1 = Translation(-center);
rotMat = createRotation(angle);
R = MatrixAffineTransform(rotMat);
T2 = Translation(center);

% get transform matrices
t1Mat = T1.getAffineMatrix();
t2Mat = T2.getAffineMatrix();
resMat = t2Mat*rotMat*t1Mat;

% create composed transforms
Res1 = MatrixAffineTransform(resMat);
Res2 = T2.compose(R).compose(T1);
Res3 = CenteredMotionTransform2D([30 0 0], 'center', center);

%% transform a set of points using both transforms
pts0 = [5 6; 3 4;-1 2];
pts1 = Res1.transformPoint(pts0);
pts2 = Res2.transformPoint(pts0);
pts3 = Res3.transformPoint(pts0);

% transformed points should be the same
assertElementsAlmostEqual(pts1, pts2);
assertElementsAlmostEqual(pts1, pts3);
