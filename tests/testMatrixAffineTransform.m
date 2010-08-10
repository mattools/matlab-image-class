function test_suite = testMatrixAffineTransform(varargin)
%TESTMATRIXAFFINETRANSFORM  One-line description here, please.
%   output = testMatrixAffineTransform(input)
%
%   Example
%   testMatrixAffineTransform
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

function testCreateFromArray

% identity
mat1 = eye(3);
T = MatrixAffineTransform(mat1);
assertTrue(T.isvalid());

% do not specify last line
mat1 = mat1(1:end-1, :);
T = MatrixAffineTransform(mat1);
assertTrue(T.isvalid());

