function tests = test_areaOpening
% Test suite for the file areaOpening.
%
%   Test suite for the file areaOpening
%
%   Example
%   test_areaOpening
%
%   See also
%     areaOpening

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-11-25,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple_binary(testCase) %#ok<*DEFNU>
% Test call of function without argument.

% create default label image
data = zeros(8, 8, 'uint8');
data(2, 2) = 2;
data(2, 4:7) = 4;
data(4:7, 2) = 5;
data(4:7, 4:7) = 8;
img = Image(data>0);

imgOp = areaOpening(img, 3);

% expect to keep three connected components
lbl = componentLabeling(imgOp, 4);
assertEqual(testCase, max(lbl), 3);


function test_Simple_label(testCase) %#ok<*DEFNU>
% Test call of function without argument.

% create default label image
data = zeros(8, 8, 'uint8');
data(2, 2) = 2;
data(2, 4:7) = 4;
data(4:7, 2) = 5;
data(4:7, 4:7) = 8;
img = Image(data, 'Type', 'Label');

imgOp = areaOpening(img, 3);

% expect result to be a label image
assertTrue(testCase, isLabelImage(imgOp));

% expect to keep three connected components
% (recompute labels)
labelList = unique(imgOp(imgOp>0));
assertEqual(testCase, length(labelList), 3);

