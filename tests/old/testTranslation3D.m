function test_suite = testTranslation3D(varargin)
%TESTTRANSLATION3D  Test function for class Translation3D
%   output = testTranslation3D(input)
%
%   Example
%   testTranslation3D
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-03,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


initTestSuite;

function testConstructor

% test empty constructor
trans = Translation3D();
assertTrue(trans.isvalid());

% test constructor with separate arguments
trans = Translation3D(2, 3, 4);
assertTrue(trans.isvalid());

% test constructor with bundled arguments
trans = Translation3D([2, 3, 4]);
assertTrue(trans.isvalid());

% test copy constructor
trans2 = Translation3D(trans);
assertTrue(trans2.isvalid());


function testIsa

trans = Translation3D(2, 3, 4);
assertTrue(isa(trans, 'Transform'));
assertTrue(isa(trans, 'Transform3D'));


