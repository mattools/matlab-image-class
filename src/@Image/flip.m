function res = flip(this, d)
%FLIP Flip an image along one of its dimensions
%
%   IMG2 = IMG.flip(D);
%   IMG2 = flip(IMG, D);
%   Flips the image IMG with respect to the axis D.
%   D=1 corresponds to x axis
%   D=2 corresponds to y axis
%
%   IMG2 = IMG.flip;
%   flip with respect to first axis (horizontal flip)
%
%   Example
%   % flip an image in the x axis
%   img = Image2D('rice.png');
%   img2 = flip(img, 1);
%   img2.show();
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-02-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% ensure dimension is given
if nargin==1
    d = 1;
end

% check dim
if d > getDimension(this)
    error('Can not flip a dimension greater than image dimension');
end

% create empty result image
res = Image(2, 'data', flipdim(this.data, d), 'parent', this);
