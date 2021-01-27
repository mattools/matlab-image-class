function tests = test_orthogonalProjection
% Test suite for the file orthogonalProjection.
%
%   Test suite for the file orthogonalProjection
%
%   Example
%   test_orthogonalProjection
%
%   See also
%     orthogonalProjection

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-27,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_Proj_Z(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = createTestImage3d();

projXY = orthogonalProjection(img, 3, 'max'); 

assertEqual(testCase, size(projXY), [30 20]);



function test_Proj_Z_mean(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = createTestImage3d();

projXY = orthogonalProjection(img, 3, 'mean'); 

assertEqual(testCase, size(projXY), [30 20]);


function test_Proj_Y(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = createTestImage3d();

projXZ = orthogonalProjection(img, 2, 'max'); 

assertEqual(testCase, size(projXZ), [30 1 10]);


function test_Proj_X(testCase) %#ok<*DEFNU>
% Test call of function without argument.

img = createTestImage3d();

projYZ = orthogonalProjection(img, 1, 'max'); 

assertEqual(testCase, size(projYZ), [1 20 10]);


function img = createTestImage3d
% Create an image with size 30x20x10 containing a 20x10x5 cuboid.

data = zeros([30 20 10], 'uint8');
data(6:25, 6:15, 3:7) = 100;
img = Image('Data', data);
