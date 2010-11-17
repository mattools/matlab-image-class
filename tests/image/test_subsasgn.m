function test_suite = test_subsasgn(varargin) %#ok<STOUT>
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

initTestSuite;


function test_subsasgn_2d %#ok<*DEFNU>

lx = 0:1:5;
ly = 0:10:30;
[x y] = meshgrid(lx, ly);
dat = x+y;
img = Image.create(dat);

% set one element
img(1) = 99;
assertEqual(99, img(1));
img(2) = 99;
assertEqual(99, img(2));
img(end) = 99;
assertEqual(99, img(end));

% get one row (y = cte)
new = 8:2:18;
img(:,2) = new;
assertEqual(new, img(:, 2));

% get last row (y = cte)
img(:,end) = new;
assertEqual(new, img(:, end));

% get one column (x = cte)
new = (12:3:21)';
img(1,:) = new;
assertEqual(new, img(1,:));

% get last column (x = cte)
img(end,:) = new;
assertEqual(new, img(end,:));


function test_subsasgn_3d

lx = 0:1:5;
ly = 0:10:30;
lz = 0:100:200;
[x y z] = meshgrid(lx, ly, lz);
dat = x+y+z;

img = Image.create(dat);

% set one element
img(1) = 99;
assertEqual(99, img(1));
img(2) = 99;
assertEqual(99, img(2));
img(end) = 99;
assertEqual(99, img(end));

% get one row (y = cte)
new = 8:2:18;
img(:, 2, 1) = new;
assertEqual(new, img(:, 2, 1));

% get last row (y = cte)
img(:, end, 1) = new;
assertEqual(new, img(:, end, 1));

% get one column (x = cte)
new = (12:3:21)';
img(2, :, 1) = new;
assertEqual(new, img(2, :, 1));

% get last column (x = cte)
img(end, :, 1) = new;
assertEqual(new, img(end, :, 1));

