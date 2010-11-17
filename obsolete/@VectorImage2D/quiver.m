function varargout = quiver(this, varargin)
%QUIVER  Quiver plot of a gradient image
%
%   output = quiver(input)
%
%   Example
%   quiver
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if isempty(varargin)
    % use default x, y, dx and dy
    x = this.getX();
    y = this.getY();
elseif length(varargin)==2
    % use dx and dy that corresponds to specified x and y
    x = varargin{1};
    y = varargin{2};
else
    error('Wrong number of arguments in quiver');
end

% default channels
c1 = 1;
c2 = 2;

dx = this.data(:, :, c1)';
dy = this.data(:, :, c2)';

h = quiver(x, y, dx, dy);

if nargout>0
    varargout{1} = h;
end
