function test_suite = test_show(varargin) %#ok<STOUT>
%TEST_SHOW  One-line description here, please.
%
%   output = test_show(input)
%
%   Example
%   test_show
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


function test_simple() %#ok<*DEFNU>

% test with image full of ones
dat = ones(10, 15);
img = Image.create(dat);
figure(1);
img.show();
close(1);

% test with random uint8 image
dat = uint8(randi(255, [10 15]));
img = Image.create(dat);
figure(1);
img.show();
close(1);

