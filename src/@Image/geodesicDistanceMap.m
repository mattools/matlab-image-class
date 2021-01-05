function dist = geodesicDistanceMap(marker, mask, varargin)
% Geodesic distance transform for binary or label images.
%
%   RES = geodesicDistanceMap(MARKER, MASK);
%   where MASK and MARKER are binary images the same size, computes for
%   each foreground pixel the minimum distance to the marker, using a path
%   that is contained in the foreground. If the markers can not be reached
%   from a foreground pixel, the corresponding result is Inf. 
%   The function propagates distances using chamfer weights, that
%   approximate the Euclidean distance to neighbor pixels.
%
%   RES = geodesicDistanceMap(..., WEIGHTS);
%   Specifies different weights for computing distance between 2 pixels.
%   WEIGHTS is a 2 elements array, with WEIGHTS(1) corresponding to the
%   distance between two orthonal pixels, and WEIGHTS(2) corresponding to
%   the distance between two diagonal pixels.
%   Possible choices
%   WEIGHTS = [5 7 11]      -> best choice for 5x5 chamfer masks (default)
%   WEIGHTS = [1 sqrt(2)]   -> quasi-euclidean distance
%   WEIGHTS = [1 Inf]       -> "Manhattan" or "cityblock" distance
%   WEIGHTS = [1 1]         -> "Chessboard" distance
%   WEIGHTS = [3 4]         -> Borgerfors' weights
%   WEIGHTS = [5 7]         -> close approximation of sqrt(2)
%
%   Note: when specifying weights, the result has the same class/data type
%   than the array of weights. It is possible to balance between speed and
%   memory usage:
%   - if weights are double (the default), the memory usage is high, but
%       the result can be given in pixel units 
%   - if weights are integer (for Borgefors weights, for example), the
%       memory usage is reduced, but representation limit of datatype can
%       be easily reached. One needs to divide by the first weight to get
%       result comparabale with natural distances.
%       For uint8, using [3 4] weigths, the maximal computable distance is
%       around 255/3 = 85 pixels. Using 'int16'  seems to be a good
%       tradeoff, the maximal distance with [3 4] weights is around 11000
%       pixels.
%
%   RES = geodesicDistanceMap(..., 'verbose', true);
%   Displays info on iterations.
%
%   Example
%     % computes distance function inside a complex particle
%     mask = Image.read('circles.png');
%     marker = Image.false(size(mask));
%     marker(80, 80) = 1;
%     % compute using quasi-enclidean weights
%     dist = geodesicDistanceMap(marker, mask);
%     figure; show(double2rgb(dist));
%     title('Geodesic distance map');
%
%     % compute the same distance map but using integer weights, giving
%     % integer results.
%     dist34 = geodesicDistanceMap(marker, mask, int16([3 4]));
%     % convert to double, taking into account values out of mask
%     dist34 = double(dist34) / 3;
%     dist34(~mask) = inf;
%     % display result
%     rgb = double2rgb(dist34);
%     figure; show(rgb); title('Geodesic distance map, integer weights');
%
%
%   The function uses scanning algorithm. Each iteration consists in a
%   sequence of a forward and a backward scan. Iterations stop when
%   stability is reached.
%
%   See also
%     distanceMap, reconstruction
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-10-19,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.


%% Default options

% default weights for orthogonal, diagonal, and chess-knight neighbors
weights = [5 7 11];

normalize = true;

% silent processing by default
verbose = false;


%% Process input arguments

% extract user-specified weights
if ~isempty(varargin) && isnumeric(varargin{1})
    weights = varargin{1};
    varargin(1) = [];
end
 
% extract verbosity option
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


%% Pre-Processing

if size(marker) ~= size(mask)
    error('Marker and mask image must have same size');
end

% extract weights in specific directions
w1 = weights(1);
w2 = weights(2);

% small check up to avoid degenerate cases
if w2 == 0
    w2 = 2 *  w1;
end

% initialize weight associated to chess-knight move
if length(weights) == 2
    nShifts = 4;
    % the list of shifts for forward scans (shift in y, shift in x, weight)
    fwdShifts = [...
        -1 -1; ...
        -1  0; ...
        -1 +1; ...
         0 -1];
    
    % the list of shifts for backward scans (shift in y, shift in x, weight)
    bckShifts = [...
        +1 +1; ...
        +1  0; ...
        +1 -1; ...
         0 +1];
    ws = [w2 w1 w2 w1];
else
    w3 = weights(3);
    nShifts = 8;
    
    % the list of shifts for forward scans (shift in y, shift in x, weight)
    fwdShifts = [...
        -2 -1; ...
        -2 +1; ...
        -1 -2; ...
        -1 -1; ...
        -1  0; ...
        -1 +1; ...
        -1 +2; ...
         0 -1 ];
    
    % the list of shifts for backward scans (shift in y, shift in x, weight)
    bckShifts = [...
        +2 +1; ...
        +2 -1; ...
        +1 +2; ...
        +1 +1; ...
        +1  0; ...
        +1 -1; ...
        +1 -2; ...
         0 +1];
    ws = [w3 w3 w3 w2 w1 w2 w3 w1];
end

% determines type of output from type of weights
outputType = class(w1);

% allocate memory for result
dist = ones(size(mask), outputType);

% init result: either max value, or 0 for marker pixels
if isinteger(w1)
    dist(:) = intmax(outputType);
else
    dist(:) = inf;
end
dist(marker) = 0;

% size of image
[D1, D2] = size(mask);


%% Iterations until no more changes

% apply forward and backward iteration until no more changes are made
modif = true;
nIter = 1;
while modif
    modif = false;
    
    %% Forward iteration
    
    if verbose
        disp(sprintf('Forward iteration %d', nIter)); %#ok<DSPS>
    end
    
    % forward iteration on lines
    for i = 1:D1
        % process all pixels inside the current line
        for j = 1:D2
            % computes only for pixel inside mask
            if mask.Data(i, j) == 0
                continue;
            end
            
            % compute minimal propagated distance around neighbors in
            % forward mask
            newVal = dist(i, j);
            for k = 1:nShifts
                % coordinate of neighbor
                i2 = i + fwdShifts(k, 1);
                j2 = j + fwdShifts(k, 2);
                
                % check bounds of neighbor
                if i2 < 1 || i2 > D1
                    continue;
                end
                if j2 < 1 || j2 > D2
                    continue;
                end
                
                % compute new value of local distance map
                if mask.Data(i2, j2) == mask.Data(i, j)
                    % neighbor in same region
                    % -> add offset weight to neighbor distance
                    newVal = min(newVal, dist(i2, j2) + ws(k));
                end
            end
            
            % if distance was changed, update result, and toggle flag
            if newVal < dist(i,j)
                modif = true;
                dist(i,j) = newVal;
            end
        end
        
    end % iteration on lines

    % check end of iteration
    if ~modif && nIter ~= 1
        break;
    end
    
    %% Backward iteration
    modif = false;
    
    if verbose
        disp(sprintf('Backward iteration %d', nIter)); %#ok<DSPS>
    end
    
    % backward iteration on lines
    for i = D1:-1:1
        % process all pixels inside the current line
        for j = D2:-1:1
            % computes only for pixel inside mask
            if mask.Data(i, j) == 0
                continue;
            end
            
            % compute minimal propagated distance around neighbors in
            % backward mask
            newVal = dist(i, j);
            for k = 1:nShifts
                % coordinate of neighbor
                i2 = i + bckShifts(k, 1);
                j2 = j + bckShifts(k, 2);
                
                % check bounds of neighbor
                if i2 < 1 || i2 > D1
                    continue;
                end
                if j2 < 1 || j2 > D2
                    continue;
                end
                
                % compute new value of local distance map
                if mask.Data(i2, j2) == mask.Data(i, j)
                    % neighbor in same region
                    % -> add offset weight to neighbor distance
                    newVal = min(newVal, dist(i2, j2) + ws(k));
                end
            end
               
            % if distance was changed, update result, and toggle flag
            if newVal < dist(i,j)
                modif = true;
                dist(i,j) = newVal;
            end
        end
        
    end % line iteration
    
    nIter = nIter+1;
end % until no more modif

% normalize map
if normalize
    dist(mask > 0) = dist(mask > 0) / w1;
end

name = createNewName(mask, '%s-geodDistMap');
dist = Image('Data', dist, 'Parent', mask, 'Type', 'Intensity', 'Name', name);
