function [coords dim varargin] = mergeCoordinates(varargin)
%MERGECOORDINATES Merge all coordinates into a single N-by-ND array
%
% [coords dim] = mergeCoordinates(X, Y)
% [coords dim] = mergeCoordinates(X, Y, Z)
%

% case of coordinates already grouped: use default results
coords = varargin{1};
dim = [size(coords,1) 1];
nbCoord = 1;

% Count the number of input arguments the same size as point
coordSize = size(coords);
for i = 2:length(varargin)
    % extract next input and compute its size
    var = varargin{i};
    varSize = size(var);
    
    % continue only if input is numeric has the same size
    if ~isnumeric(var)
        break;
    end
    if length(varSize) ~= length(coordSize)
        break;
    end
    if sum(varSize ~= coordSize) > 0
        break;
    end
    
    nbCoord = i;
end

% if other variables were found, we need to concatenate them
if nbCoord > 1
    % create new point array, and store input dimension
    dim = size(coords);
    coords = zeros(numel(coords), length(dim));
    
    % iterate over dimensions
    for i = 1:nbCoord
        var = varargin{i};
        coords(:, i) = var(:);
    end
end

varargin(1:nbCoord) = [];
