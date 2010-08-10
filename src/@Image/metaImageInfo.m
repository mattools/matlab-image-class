function info = metaImageInfo(fileName)
% Read information header of meta image data
%   output = metaImageInfo(input)
%
%   Example
%   info = metaImageInfo('example.hdr');
%   X = metaImageRead(info);
%
%   TODO: add support for multiple image
%
%   See also
%   metaImageRead, readstack, analyze75info
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-01-27,    using Matlab 7.9.0.529 (R2009b)
% http://www.pfl-cepia.inra.fr/index.php?page=slicer
% Copyright 2010 INRA - Cepia Software Platform.

% add extension if not present
ext = [];
if length(fileName)>3
    ext = fileName(end-3:end);
end
if ~strcmp(ext, '.mhd')
    fileName = [fileName '.mhd'];
end

% get base directory
path = fileparts(fileName);

% open the file for reading
f = fopen(fileName, 'rt');

% extract key and value of current line
[tag string] = splitLine(fgetl(f));

% check header file contains an image
if ~strcmp(tag, 'ObjectType') || ~strcmp(string, 'Image')
    error('File should contain image data');
end

% default values
info.NDims = 0;
info.DimSize = [];
info.ElementType = 'uint8';
info.ElementDataFile = '';

% default optional values
info.HeaderSize = 0;

while true
    % read current line, if exists
    line = fgetl(f);
    if line==-1
        break
    end

    % extract key and value of current line
    [tag string] = splitLine(line);
    
    % extract each possible tag
    switch tag
        case 'NDims'
            nd = sscanf(string, '%d');
            info.NDims = nd;
            
            % setup default values for spatial calibration
            info.ElementSpacing = ones(1, nd);
            info.ElementSize = ones(1, nd);
        case 'DimSize'
            info.DimSize = sscanf(string, '%d', inf)';
        case 'ElementType'
            info.ElementType = string;
        case 'HeaderSize'
            info.HeaderSize = sscanf(string, '%d');
        case 'ElementSize'
            info.ElementSize = sscanf(string, '%f', inf)';
        case 'ElementSpacing'
            info.ElementSpacing = sscanf(string, '%f', inf)';
        case 'ElementByteOrderMSB'
            info.ElementByteOrderMSB = parseBoolean(string);
        case 'ElementNumberOfChannels'
            info.ElementNumberOfChannels = sscanf(string, '%d');
        case 'BinaryData'
            info.BinaryData = parseBoolean(string);
        case 'BinaryDataByteOrderMSB'
            info.BinaryDataByteOrderMSB = parseBoolean(string);
        case 'ElementDataFile'
            info.ElementDataFile = fullfile(path, string);
        otherwise
            disp(['unknown tag in MetaImage header: ' tag]);
            info.(tag) = string;
    end
end

fclose(f);


function [tag string] = splitLine(line)
[tag remain] = strtok(line, '=');
tag = strtrim(tag);
string = strtrim(strtok(remain, '='));


function b = parseBoolean(string)
b = strcmpi(string, 'true');
