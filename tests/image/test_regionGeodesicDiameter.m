function tests = test_regionGeodesicDiameter
% Test suite for the file regionGeodesicDiameter.
%
%   Test suite for the file regionGeodesicDiameter
%
%   Example
%   test_regionGeodesicDiameter
%
%   See also
%     regionGeodesicDiameter

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-11-18,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


% function test_Simple(testCase) %#ok<*DEFNU>
% % Test call of function without argument.
% regionGeodesicDiameter();
% value = 10;
% assertEqual(testCase, value, 10);

function test_Square5x5(testCase) %#ok<*DEFNU>

img = Image.false(8, 8);
img(2:6, 3:7) = 1;

assertEqual(testCase, (2*11+2*5+1)/5, regionGeodesicDiameter(img));
assertEqual(testCase, 5, regionGeodesicDiameter(img, [1 1]));
assertEqual(testCase, 9, regionGeodesicDiameter(img, [1 2]));
assertEqual(testCase, 19/3, regionGeodesicDiameter(img, [3 4]));


function test_SmallSpiral(testCase) %#ok<*DEFNU>

data = [...
    0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0; ...
    0 1 1 1 1 1 1 1 1 0; ...
    0 0 0 0 0 0 0 1 1 0; ...
    0 0 1 1 1 1 0 0 1 0; ...
    0 1 0 0 0 1 0 0 1 0; ...
    0 1 1 0 0 0 0 1 1 0; ...
    0 0 1 1 1 1 1 1 1 0; ...
    0 0 0 0 1 1 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0];

% number of orthogonal and diagonal move between extremities
no = 5 + 1 + 3 + 2;
nd = 2 + 2 + 3 + 1;

img = Image(data, 'type', 'binary');

exp11 = no + nd + 1;
assertEqual(testCase, exp11, regionGeodesicDiameter(img, [1 1]));
exp12 = no + nd*2 + 1;
assertEqual(testCase, exp12, regionGeodesicDiameter(img, [1 2]));
exp34 = (no*3 + nd*4)/3 + 1;
assertEqual(testCase, exp34, regionGeodesicDiameter(img, [3 4]));



function test_VerticalLozenge(testCase)
% vertical lozenge that did not pass test with first version of algo

img = Image([...
    0 0 0 0 0 0 0 ; ...
    0 0 0 1 0 0 0 ; ...
    0 0 1 1 1 0 0 ; ...
    0 0 1 1 1 0 0 ; ...
    0 1 1 1 1 1 0 ; ...
    0 0 1 1 1 0 0 ; ...
    0 0 1 1 1 0 0 ; ...
    0 0 0 1 0 0 0 ; ...
    0 0 0 0 0 0 0 ; ...
    ], 'type', 'binary');
exp = 7;

assertEqual(testCase, exp, regionGeodesicDiameter(img));
assertEqual(testCase, exp, regionGeodesicDiameter(img, [1 1]));
assertEqual(testCase, exp, regionGeodesicDiameter(img, [1 2]));
assertEqual(testCase, exp, regionGeodesicDiameter(img, [3 4]));
assertEqual(testCase, uint16(exp), regionGeodesicDiameter(img, uint16([3 4])));


function test_SeveralParticles(testCase)

img = Image(zeros([10 10]), 'type', 'label');
img(2:4, 2:4) = 1; 
img(6:9, 2:4) = 2; 
img(2:4, 6:9) = 3; 
img(6:9, 6:9) = 4; 

exp11 = [2 3 3 3]' + 1;
exp12 = [4 5 5 6]' + 1;
exp34 = [8/3 11/3 11/3 12/3]' + 1;

% test on label image
assertEqual(testCase, exp11, regionGeodesicDiameter(img, [1 1]));
assertEqual(testCase, exp12, regionGeodesicDiameter(img, [1 2]));
assertEqual(testCase, exp34, regionGeodesicDiameter(img, [3 4]));


function test_SeveralParticles_UInt16(testCase)

img = Image(zeros([10 10]), 'type', 'label');
img(2:4, 2:4) = 1; 
img(6:9, 2:4) = 2; 
img(2:4, 6:9) = 3; 
img(6:9, 6:9) = 4; 

exp11 = uint16([2 3 3 3]' + 1);
exp12 = uint16([4 5 5 6]' + 1);
exp34 = uint16([8/3 11/3 11/3 12/3]' + 1);

% test on label image
assertEqual(testCase, exp11, regionGeodesicDiameter(img, uint16([1 1])));
assertEqual(testCase, exp12, regionGeodesicDiameter(img, uint16([1 2])));
assertEqual(testCase, exp34, regionGeodesicDiameter(img, uint16([3 4])));


function test_TouchingRegions(testCase)

img = Image([...
    0 0 0 0 0 0 0 0; ...
    0 1 1 2 2 3 3 0; ...
    0 1 1 2 2 3 3 0; ...
    0 1 1 4 4 3 3 0; ...
    0 1 1 4 4 3 3 0; ...
    0 1 1 5 5 3 3 0; ...
    0 1 1 5 5 3 3 0; ...
    0 0 0 0 0 0 0 0; ...
], 'type', 'label');

exp11 = [5 1 5 1 1]' + 1;
exp12 = [6 2 6 2 2]' + 1;
exp34 = [16 4 16 4 4]'/3 + 1;

assertEqual(testCase, exp11, regionGeodesicDiameter(img, [1 1]));
assertEqual(testCase, exp12, regionGeodesicDiameter(img, [1 2]));
assertEqual(testCase, exp34, regionGeodesicDiameter(img, [3 4]));


function test_MissingLabels(testCase)

img = Image([...
    0 0 0 0 0 0 0 0 0 0; ...
    0 1 1 0 2 2 0 3 3 0; ...
    0 1 1 0 2 2 0 3 3 0; ...
    0 1 1 0 0 0 0 3 3 0; ...
    0 1 1 0 7 7 0 3 3 0; ...
    0 1 1 0 7 7 0 3 3 0; ...
    0 1 1 0 0 0 0 3 3 0; ...
    0 1 1 0 9 9 0 3 3 0; ...
    0 1 1 0 9 9 0 3 3 0; ...
    0 0 0 0 0 0 0 0 0 0; ...
], 'Type', 'Label');

exp11 = [7 1 7 1 1]' + 1;
exp12 = [8 2 8 2 2]' + 1;
exp34 = [22 4 22 4 4]'/3 + 1;

% test on label image
assertEqual(testCase, exp11, regionGeodesicDiameter(img, [1 1]));
assertEqual(testCase, exp12, regionGeodesicDiameter(img, [1 2]));
assertEqual(testCase, exp34, regionGeodesicDiameter(img, [3 4]));


function test_OutputLabels(testCase)

img = Image([...
    0 0 0 0 0 0 0 0 0 0; ...
    0 1 1 0 2 2 0 3 3 0; ...
    0 1 1 0 2 2 0 3 3 0; ...
    0 1 1 0 0 0 0 3 3 0; ...
    0 1 1 0 7 7 0 3 3 0; ...
    0 1 1 0 7 7 0 3 3 0; ...
    0 1 1 0 0 0 0 3 3 0; ...
    0 1 1 0 9 9 0 3 3 0; ...
    0 1 1 0 9 9 0 3 3 0; ...
    0 0 0 0 0 0 0 0 0 0; ...
], 'type', 'label');

exp1 = [22 4 22 4 4]'/3 + 1;
exp2 = [1 2 3 7 9]';

% test on label image
[res, labels] = regionGeodesicDiameter(img, [3 4]);
assertEqual(testCase, exp1, res);
assertEqual(testCase, exp2, labels);
