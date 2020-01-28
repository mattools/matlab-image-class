function info = readMetaImageInfo(fileName)
% Read information header of meta image data.
%
%   INFO = readMetaImageInfo(FILENAME)
%
%   Example
%   info = metaImageInfo('example.hdr');
%   X = metaImageRead(info);
%
%   See also
%     readMetaImage, readstack, analyze75info
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-01-27,    using Matlab 7.9.0.529 (R2009b)


%% Open info file

% extract file name parts
[path, baseName, ext] = fileparts(fileName); %#ok<ASGLU>

% add extension if not present
if isempty(ext)
    fileName = [fileName '.mhd'];
end

% open the file for reading
f = fopen(fileName, 'rt');


%% Initialisations

% extract key and value of current line
[tag, string] = splitLine(fgetl(f));

% check header file contains an image
if ~strcmp(tag, 'ObjectType') || ~strcmp(string, 'Image')
    error('File should contain image data');
end

% default values
info.ObjectType = 'Image';
info.NDims = 0;
info.DimSize = [];
info.ElementType = 'uint8';
info.ElementDataFile = '';

% default optional values
info.HeaderSize = 0;


%% Iterates over lines in the file

while true
    % read current line, if exists
    line = fgetl(f);
    if line==-1
        break
    end

    % extract key and value of current line
    [tag, string] = splitLine(line);
    
    % extract each possible tag
    switch tag
        % First parse mandatory tags
        case 'NDims'
            % number of dimensions. Used for initializing data structure.
            nd = parseInteger(string);
            info.NDims = nd;
            
            % setup default values for spatial calibration
            info.ElementSpacing = ones(1, nd);
            info.ElementSize = ones(1, nd);
        case 'DimSize'
            info.DimSize = parseIntegerVector(string);
        case 'ElementType'
            info.ElementType = string;
        case 'HeaderSize'
            info.HeaderSize = parseInteger(string);
        case 'ElementDataFile'
            info.ElementDataFile = computeDataFileName(string, f, path);
            % local keyword indicates data are stored right after this tag
            if strcmpi(info.ElementDataFile, 'Local')
                info.ElementDataFile = fileName;
                info.HeaderSize = ftell(f);
            end
            
            % this tag is supposed to be the last one in the tag list
            break;
            
        % Following tags are optional, but often encountered
            
        case 'ElementSize'
            info.ElementSize = parseFloatVector(string);
        case 'ElementSpacing'
            info.ElementSpacing = parseFloatVector(string);
        case 'ElementByteOrderMSB'
            info.ElementByteOrderMSB = parseBoolean(string);
        case 'ElementNumberOfChannels'
            info.ElementNumberOfChannels = parseInteger(string);
        case 'BinaryData'
            info.BinaryData = parseBoolean(string);
        case 'BinaryDataByteOrderMSB'
            info.BinaryDataByteOrderMSB = parseBoolean(string);
        case 'CompressedData'
            info.CompressedData = parseBoolean(string);
            
        case 'CompressedDataSize'
            info.CompressedData = parseIntegerVector(string);
            
        % Some less common tags, used e.g. by Elastix
        
        case 'AnatomicalOrientation'
            info.AnatomicalOrientation = string;
            
        case 'CenterOfRotation'
            info.CenterOfRotation = parseFloatVector(string);
            
        case 'Offset'
            info.Offset = parseFloatVector(string);
            
        case 'TransformMatrix'
            info.TransformMatrix = parseFloatVector(string);

        otherwise
            disp(['Unknown tag in MetaImage header: ' tag]);
            info.(tag) = string;
    end
end

fclose(f);


function [tag, string] = splitLine(line)
[tag, remain] = strtok(line, '=');
tag = strtrim(tag);
string = strtrim(strtok(remain, '='));


function name = computeDataFileName(string, f, path)
% compute filename or file name list from pattern and current path

% remove eventual trailing spaces
string = strtrim(string);

if strcmpi(string, 'list')
    % read the list of file names and add the path
    tline = fgetl(f);
    name = {};
    i = 1;
    while ischar(tline)
        name{i} = fullfile(path, tline); %#ok<AGROW>
        i = i + 1;
        tline = fgetl(f);
    end
    
elseif contains(string, ' ')
    % If filename contains spaces, it is parsed to extract indices
    C = textscan(string, '%s %d %d %d');
    pattern = C{1}{1};
    i0 = C{2};
    iend = C{3};
    istep = C{4};
    
    inds = i0:istep:iend;
    
    name = cell(length(inds), 1);
    
    for i = 1:length(inds)
        name{i} = fullfile(path, sprintf(pattern, inds(i)));
    end
    
else
    % Simply use the string as the name of the file
    name = fullfile(path, string);
end


function b = parseBoolean(string)
b = strcmpi(string, 'true');

function v = parseInteger(string)
v = sscanf(string, '%d');

function v = parseIntegerVector(string)
v = sscanf(string, '%d', inf)';

function v = parseFloatVector(string)
v = sscanf(string, '%f', inf)';
