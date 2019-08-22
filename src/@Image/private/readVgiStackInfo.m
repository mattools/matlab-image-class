function info = readVgiStackInfo(fileName, varargin)
% Read information necessary to load a 3D stack in VGI format.
%
%   INFO = readVgiStackInfo(FILENAME)
%   INFO = readVgiStackInfo(FILENAME, 'verbose', VERB)
%   Also specifies a verbosity level (default: 0).
%
%   Example
%   vgiStackInfo
%
%   See also
%     readVgiStack
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-10-24,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2018 INRA - Cepia Software Platform.

%% Initialisations

% Initialize empty stucture 
info.SizeX = 0;
info.SizeY = 0;
info.SizeZ = 0;
info.BitDepth = 0;
info.LittleEndian = true;
info.DataFileName = '';
info.Spacing = [];
info.Unit = '';

% parse optional input arguments
verbose = false;
while length(varargin) >= 2
    name = varargin{1};
    if strcmp(name, 'verbose')
        verbose = varargin{2};
    end
    varargin(1:2) = [];
end


%% Read File info

f = fopen(fileName, 'rt');
if f == -1
    error(['Could not find the file: ' fileName]);
end

% iterate over text lines
lineIndex = 0;
while true
    % read next line
    line = fgetl(f);
    lineIndex = lineIndex + 1;
    
    % end of file
    if line == -1
        break;
    end
    line = strtrim(line);
    
    if startsWith(line, '{') && endsWith(line, '}')
        % start a new volume
        if verbose > 1
            disp(['start a new volume: ' line(2:end-1)]);
        end

    elseif startsWith(line, '[') && endsWith(line, ']')
        % start a new information block
        if verbose > 1
            disp(['start a new information block: ' line(2:end-1)]);
        end
        
    else 
        % process new key-value pair
        [key, value] = strtok(line, '=');
        if isempty(value)
            error('Token count error at line %d: %s', lineIndex, line);
        end
        
        % extract key and value for the current line
        key = strtrim(key);
        value = strtrim(value(2:end));
        
        % switch process depending on key
        if strcmpi(key, 'Size')
            % process volume dimension
            tokens = strsplit(value, ' ');
            info.SizeX = str2double(tokens{1});
            info.SizeY = str2double(tokens{2});
            info.SizeZ = str2double(tokens{3});
            
        elseif strcmpi(key, 'BitsPerElement')
            info.BitDepth = str2double(value);
            if info.BitDepth ~= 16
                error('Only 16 bits per element are currently supported, not %d', info.BitDepth);
            end
            
        elseif strcmp(key, 'Name')
            info.DataFileName = value;
            
        elseif strcmpi(key, 'Resolution')
            tokens = strsplit(value, ' ');
            if length(tokens) ~= 3
                error('Could not parse spatial resolution from line: %d', line);
            end
            info.Spacing(1) = str2num(tokens{1}); %#ok<ST2NM>
            info.Spacing(2) = str2num(tokens{2}); %#ok<ST2NM>
            info.Spacing(3) = str2num(tokens{3}); %#ok<ST2NM>
            
        elseif strcmpi(key, 'Unit')
            info.Unit = value;
            
        end
    end
end

% close the file containing information
fclose(f);
