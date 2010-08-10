function test_suite = testTranslation2D(varargin)
%TESTTRANSLATION2D  Test function for class Translation2D
%   output = testTranslation2D(input)
%
%   Example
%   testTranslation2D
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
trans = Translation2D();
assertTrue(trans.isvalid());

% test constructor with separate arguments
trans = Translation2D(2, 3);
assertTrue(trans.isvalid());

% test constructor with bundled arguments
trans = Translation2D([2, 3]);
assertTrue(trans.isvalid());

% test copy constructor
trans2 = Translation2D(trans);
assertTrue(trans2.isvalid());


function testIsa

trans = Translation2D(2, 3);
assertTrue(isa(trans, 'Transform'));
assertTrue(isa(trans, 'Transform2D'));


