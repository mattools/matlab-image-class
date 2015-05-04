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
%   interp2, lineProfile
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Process input arguments

nd = ndims(this);
[point, dim, varargin] = mergeCoordinates(varargin{:});

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

nv = size(point, 1);
nc = channelNumber(this);
val = zeros(nv, nc);

if nd == 2
    % planar case
    x = xData(this);
    y = yData(this);
    
    if nc == 1
        val = interp2(y, x, double(this.data), ...
            point(:, 2), point(:, 1), method, fillValue);
    else
        for i = 1:nc
            img2 = channel(this, i);
            val(:, i) = interp2(y, x, double(img2.data), ...
                point(:, 2), point(:, 1), method, fillValue);
        end
    end
elseif nd == 3
    % 3D Case
    x = xData(this);
    y = yData(this);
    z = zData(this);
    if nc == 1
        val = interp3(y, x, z, double(this.data), ...
            point(:, 2), point(:, 1), point(:, 3), method, fillValue);
    else
        for i = 1:nc
            img2 = channel(this, i);
            val(:, i) = interp2(y, x, z, double(img2.data), ...
                point(:, 2), point(:, 1), point(:, 3), method, fillValue);
        end
    end
    
end  

% keep same size for result, but add one dimension for channels
if dim(end) == 1
    dim(end) = nc;
else
    dim = [dim nc];
end

val = reshape(val, dim);
