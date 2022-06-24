function val = interp(obj, varargin)
% Interpolate an image at given position(s).
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
%   interp2, lineProfile, resample
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-12-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Process input arguments

nd = ndims(obj);
[point, dim, varargin] = mergeCoordinates(varargin{:});

method = 'linear';
fillValue = 0;

if ~isempty(varargin)
    method = varargin{1};
    varargin(1) = [];
end

if ischar(method) && method(1)~='*'
    method = ['*' method];
end

if ~isempty(varargin)
    fillValue = varargin{1};
end
    

%% Compute interpolation

nv = size(point, 1);
nc = channelCount(obj);
val = zeros(nv, nc);

if nd == 2
    % planar case
    x = xData(obj);
    y = yData(obj);
    
    if nc == 1
        val(:) = interp2(y, x, double(obj.Data), ...
            point(:, 2), point(:, 1), method, fillValue);
    else
        for i = 1:nc
            img2 = channel(obj, i);
            val(:, i) = interp2(y, x, double(img2.Data), ...
                point(:, 2), point(:, 1), method, fillValue);
        end
    end
elseif nd == 3
    % 3D Case
    x = xData(obj);
    y = yData(obj);
    z = zData(obj);
    if nc == 1
        val(:) = interp3(y, x, z, double(obj.Data), ...
            point(:, 2), point(:, 1), point(:, 3), method, fillValue);
    else
        for i = 1:nc
            img2 = channel(obj, i);
            val(:, i) = interp2(y, x, z, double(img2.Data), ...
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
