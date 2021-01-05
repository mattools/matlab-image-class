function tests = test_angle
% Test suite for the file angle.
%
%   Test suite for the file angle
%
%   Example
%   test_angle
%
%   See also
%     angle

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-05,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

% create an image of complex values
imga = 5 * ones(5, 4);
imgb = 4 * ones(5, 4);
img = Image('Data', cat(4, imga, imgb), 'Type', 'complex');

res = angle(img);

assertTrue(testCase, isa(res, 'Image'));


function test_CreateName(testCase) %#ok<*DEFNU>
% Test call of function without argument.

% create an image of complex values
imga = 5 * ones(5, 4);
imgb = 4 * ones(5, 4);
img = Image('Data', cat(4, imga, imgb), 'Type', 'complex');
img.Name = 'image';

res = angle(img);

assertTrue(testCase, isa(res, 'Image'));
assertFalse(testCase, isempty(res.Name));


