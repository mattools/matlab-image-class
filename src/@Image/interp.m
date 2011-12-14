function val = interp(this, varargin)
%INTERP Interpolate an image at given position(s)
%
%   V = interp(IMG, X, Y)
%   V = interp(IMG, X, Y, Z)
%   V = interp(IMG, POS)
%   V = interp(..., 'method')
%
%   Example
%   interp
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Process input arguments

nd = ndims(this);
[point dim varargin] = mergeCoordinates(varargin{:});

method = 'linear';
fillValue = 0;

if ~isempty(varargin)
    method = varargin{1};
    varargin{1} = [];
end

if ischar(method) && method(1)~='*'
    method = ['*' method];
end

if ~isempty(varargin)
    fillValue = varargin{1};
end
    

%% Compute interpolation

if nd == 2
    % planar case
    x = xData(this);
    y = yData(this);
    val = interp2(y, x, double(this.data), ...
        point(:, 2), point(:, 1), method, fillValue);
    
elseif nd == 3
    % 3D Case
    x = xData(this);
    y = yData(this);
    z = zData(this);
    val = interp3(y, x, z, double(this.data), ...
        point(:, 2), point(:, 1), point(:, 3), method, fillValue);
    
end  

% keep same size for result
val = reshape(val, dim);
