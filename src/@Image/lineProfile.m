function varargout = lineProfile(this, varargin)
%LINEPROFILE Interpolate image value along a line segment
%
%   VALS = lineProfile(IMG, P1, P2)
%   Interpolates values within image between points P1 and P2.
%
%   VALS = lineProfile(IMG, P1, P2, N)
%
%   lineProfile(...)
%   If no output is specified, interpolated values are plotted.
%
%   Example
%   lineProfile
%
%   See also
%   interp
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-01-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if isempty(varargin)
    error('requires input argument');
end

var = varargin{1};
if size(var, 1) == 1
    % points given as separate arguments
    p1 = varargin{1};
    p2 = varargin{2};
    varargin(1:2) = [];
    
else
    % case of points specified with a point array
    p1 = var(1, :);
    p2 = var(end, :);
    varargin(1) = [];
end

nValues = sqrt(sum((p2 - p1) .^ 2));
if ~isempty(varargin) && isnumeric(varargin{1})
    nValues = varargin{1};
    varargin(1) = [];
end

method = '*linear';
if ~isempty(varargin) && ischar(varargin{1})
    method = varargin{1};
end

% coordinate of interpolation points
x = linspace(p1(1), p2(1), nValues);
y = linspace(p1(2), p2(2), nValues);

% create point array
nd = ndims(this);
if nd == 2
    pts = [x' y'];
else
    z = linspace(p1(3), p2(3), nValues);
    pts = [x' y' z'];
end

% extract corresponding pixel values
vals = interp(this, pts, method);

if nargout == 0
    % create cumulative array of distances for plotting
    dists = [0 cumsum(sqrt(sum(diff(pts, 1), 2)))'];

    % new figure for display
    figure;
    if size(vals, 2) == 3
        % display color profile
        hold on;
        plot(dists, vals(:,1), 'color', 'r');
        plot(dists, vals(:,2), 'color', 'g');
        plot(dists, vals(:,3), 'color', 'b');
        
    else
        % display intensity or multichannels profiles
        colors = get(gca, 'colororder');
        set(gca, 'colororder', colors([3 2 1 4:end], :));
        plot(dists, vals);
    end
    
    name = this.name;
    if isempty(name)
        title('Line Profile');
    else
        title(sprintf('Line profile of %s', name));
    end
    
elseif nargout > 1
    varargout{1} = vals;
    
else
    varargout = {vals, pts};
    
end
