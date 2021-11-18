function map = chamferDistanceMap(obj, varargin)
% Distance map of a binary image computed using chamfer mask.
%
%   DISTMAP = chamferDistanceMap(IMG)
%   DISTMAP = chamferDistanceMap(IMG, WEIGHTS)
%   Computes the distance map of the input image using chamfer weights. The
%   aim of this function is similar to that of the "distanceMap" one, with
%   the following specificities:
%   * possibility to use 5-by-5 chamfer masks
%   * possibility to compute distance maps for label images with touching
%   regions.
%
%   Example
%   chamferDistanceMap
%
%   See also
%     distanceMap, geodesicDistanceMap
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-11-18,    using Matlab 9.10.0.1684407 (R2021a) Update 3
% Copyright 2021 INRAE.

%% Process input arguments

% default weights for orthogonal or diagonal
weights = [5 7 11];

normalize = true;

% extract user-specified weights
if ~isempty(varargin)
    weights = varargin{1};
    varargin(1) = [];
end

% extract verbosity option
verbose = false;
if length(varargin) > 1
    varName = varargin{1};
    if ~ischar(varName)
        error('Require options as name-value pairs');
    end
    
    if strcmpi(varName, 'normalize')
        normalize = varargin{2};
    elseif strcmpi(varName, 'verbose')
        verbose = varargin{2};
    else
        error(['unknown option: ' varName]);
    end
end


%% Initialisations

% determines type of output from type of weights
outputType = class(weights);

% small check up to avoid degenerate cases
w1 = weights(1);
w2 = weights(2);
if w2 < w1
    w2 = 2 * w1;
end

% shifts in directions i and j for (1) forward and (2) backward iterations
if length(weights) == 2
    nShifts = 4;
    di1 = [-1 -1 -1  0];
    dj1 = [-1  0  1 -1];
    di2 = [+1 +1 +1  0];
    dj2 = [-1  0  1 +1];
    ws =  [w2 w1 w2 w1];
    
elseif length(weights) == 3
    nShifts = 8;
    w3 = weights(3);
    di1 = [-2 -2 -1 -1 -1 -1 -1  0];
    dj1 = [-1 +1 -2 -1  0  1 +2 -1];
    di2 = [+2 +2 +1 +1 +1 +1 +1  0];
    dj2 = [-1 +1 +2 +1  0 -1 -2 +1];
    ws =  [w3 w3 w3 w2 w1 w2 w3 w1];
end

% allocate memory for result
dist = ones(size(obj.Data), outputType);

% init result: either max value, or 0 for marker pixels
if isinteger(w1)
    dist(:) = intmax(outputType);
else
    dist(:) = inf;
end
dist(obj.Data == 0) = 0;

% size of image
[D1, D2] = size(obj.Data);


%% Forward iteration

if verbose
    disp('Forward iteration %d');
end

for i = 1:D1
    for j = 1:D2
        % computes only for pixels within a region
        if obj.Data(i, j) == 0
            continue;
        end
        
        % compute minimal propagated distance
        newVal = dist(i, j);
        for k = 1:nShifts
            % coordinate of neighbor
            i2 = i + di1(k);
            j2 = j + dj1(k);
            
            % check bounds
            if i2 < 1 || i2 > D1 || j2 < 1 || j2 > D2
                continue;
            end
            
            % compute new value
            if obj.Data(i2, j2) == obj.Data(i, j)
                % neighbor in same region 
                % -> add offset weight to neighbor distance
                newVal = min(newVal, dist(i2, j2) + ws(k));
            else
                % neighbor in another region 
                % -> initialize with the offset weight
                newVal = min(newVal, ws(k));
            end
        end
        
        % if distance was changed, update result
        dist(i,j) = newVal;
    end
    
end % iteration on lines



%% Backward iteration

if verbose
    disp('Backward iteration');
end

for i = D1:-1:1
    for j = D2:-1:1
        % computes only for foreground pixels
        if obj.Data(i, j) == 0
            continue;
        end
        
        % compute minimal propagated distance
        newVal = dist(i, j);
        for k = 1:nShifts
            % coordinate of neighbor
            i2 = i + di2(k);
            j2 = j + dj2(k);
            
            % check bounds
            if i2 < 1 || i2 > D1 || j2 < 1 || j2 > D2
                continue;
            end
            
            % compute new value
            if obj.Data(i2, j2) == obj.Data(i, j)
                % neighbor in same region 
                % -> add offset weight to neighbor distance
                newVal = min(newVal, dist(i2, j2) + ws(k));
            else
                % neighbor in another region 
                % -> initialize with the offset weight
                newVal = min(newVal, ws(k));
            end
        end
        
        % if distance was changed, update result
        dist(i,j) = newVal;
    end
    
end % line iteration

if normalize
    dist(obj.Data>0) = dist(obj.Data>0) / w1;
end

newName = createNewName(obj, '%s-distMap');

% create new image
map = Image('Data', dist, ...
    'Parent', obj, ...
    'Name', newName, ...
    'Type', 'intensity', ...
    'ChannelNames', {'distance'});
