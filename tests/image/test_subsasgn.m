function tests = test_subsasgn(varargin)
%TEST_SUBSASGN  One-line description here, please.
%
%   output = test_subsasgn(input)
%
%   Example
%   test_subsasgn
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_subsasgn_2d(testCase) %#ok<*DEFNU>

lx = 0:1:5;
ly = 0:10:30;
[x, y] = meshgrid(lx, ly);
dat = x+y;
img = Image.create(dat);

% set one element
img(1) = 99;
assertEqual(99, img(1));
img(2) = 99;
assertEqual(99, img(2));
img(end) = 99;
assertEqual(99, img(end));

% set one row (y = cte)
new = 8:2:18;
img(:,2) = new;
assertEqual(testCase, new, img(:, 2));

% set last row (y = cte)
img(:,end) = new;
assertEqual(testCase, new, img(:, end));

% set one column (x = cte)
new = (12:3:21)';
img(1,:) = new;
assertEqual(testCase, new, img(1,:));

% set last column (x = cte)
img(end,:) = new;
assertEqual(testCase, new, img(end,:));


function test_subsasgn_3d(testCase)

lx = 0:1:5;
ly = 0:10:30;
lz = 0:100:200;
[x, y, z] = meshgrid(lx, ly, lz);
dat = x+y+z;

img = Image.create(dat);

% set one element
img(1) = 99;
assertEqual(testCase, 99, img(1));
img(2) = 99;
assertEqual(testCase, 99, img(2));
img(end) = 99;
assertEqual(testCase, 99, img(end));

% set one row (y = cte)
new = 8:2:18;
img(:, 2, 1) = new;
assertEqual(testCase, new, img(:, 2, 1));

% set last row (y = cte)
img(:, end, 1) = new;
assertEqual(testCase, new, img(:, end, 1));

% set one column (x = cte)
new = (12:3:21)';
img(2, :, 1) = new;
assertEqual(testCase, new, img(2, :, 1));

% set last column (x = cte)
img(end, :, 1) = new;
assertEqual(testCase, new, img(end, :, 1));

function test_subsasgn_outside(testCase)
% If we try to assign a pixel outside, should throw an error

lx = 0:1:5;
ly = 0:10:30;
[x, y] = meshgrid(lx, ly);
dat = x+y;
img = Image.create(dat);

ok = false;
try
    img(10, 20) = 0; %#ok<NASGU>
catch %#ok<CTCH>
    ok = true;
end
assertTrue(testCase, ok);
