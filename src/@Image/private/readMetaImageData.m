function [imgData, info] = readMetaImageData(info, varargin)
% Read image data from a metaImage info file.
%
%   DATA = readMetaImageData(INFO)
%   Read the image IMG from data given in structure INFO. INFO is typically
%   returned by the 'readMetaImageInfo' function.
%   Data are returned in the natural order of the file (no permutation).
%
%   Example
%   % first load info, then load data
%   info = readMetaImageInfo('example.mhd');
%   data = readMetaImageData(info);
%
%   See also
%     readMetaImageInfo, readMetaImage
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-01-27,    using Matlab 7.9.0.529 (R2009b)
% http://www.pfl-cepia.inra.fr/index.php?page=slicer
% Copyright 2010 INRA - Cepia Software Platform.


%% Pre-compute variables

% determines pixel type
[pixelType, isArrayType] = parseMetaType(info.ElementType);

% determines number of channels
nChannels = 1;
if isfield(info, 'ElementNumberOfChannels')
    nChannels = info.ElementNumberOfChannels;
end
if nChannels > 1
    isArrayType = true;
end

% % in the case of array type, need number of channels
% nChannels = 1;
% if isArrayType
%     nChannels = info.ElementNumberOfChannels;
% end

% compute size of resulting array
% (in the case of multi-channel image, use dim=3 for channel dimension).
dims = info.DimSize;
if isArrayType
    dims = [nChannels dims];
end

% allocate memory for data
imgData = zeros(dims, pixelType);

% Specify little- or big-endian ordering
byteOrder = determineByteOrder(info);


%% Read data file(s)

if ischar(info.ElementDataFile)
    % open data file
    f = fopen(info.ElementDataFile, 'rb');
    if f == -1
        error(['Unable to open data file: ' info.ElementDataFile]);
    end

    % skip header (defined as number of bytes)
    fread(f, info.HeaderSize, 'uint8');

    % read binary data
    imgData(:) = fread(f, prod(dims), ['*' pixelType], byteOrder);

    % close file
    fclose(f);


    % convert order of elements
    if isArrayType
        % for color images, replace channel dim at fourth position
        imgData = permute(imgData, [4 1 2 3 5]);
    end

elseif iscell(info.ElementDataFile)
    % filename is given as a cell array containing name of each file
    
    % check dimension are consistent
    if length(info.ElementDataFile) ~= info.DimSize(3)
        error('Number of files does not match image third dimension');
    end
    
    % iterate over the elements in ElementDataFile, extract filename,
    % read image and add corresponding data to the img array.    
    for i = 1:length(info.ElementDataFile)
        filename = info.ElementDataFile{i};
        data = imread(filename);
        
        % use different processing for grayscale and color images
        if isArrayType
            imgData(:,:,i,:) = data;
        else
            imgData(:,:,i) = data;
        end
    end
    
else
    error('Unknown type of filename');
end

function [type, isArray] = parseMetaType(string)

% % determines if the data type is an array or a scalar
% isArray = false;
% ind = findstr(string, '_ARRAY');
% if ~isempty(ind)
%     isArray = true;
%     string = string(1:ind-1);
% end
isArray = false;

% determines the base data type
switch string
    case 'MET_UCHAR'
        type = 'uint8';
    case 'MET_CHAR'
        type = 'int8';
    case 'MET_USHORT'
        type = 'uint16';
    case 'MET_SHORT'
        type = 'int16';
    case 'MET_UINT'
        type = 'uint32';
    case 'MET_INT'
        type = 'int32';
    case 'MET_FLOAT'
        type = 'single';
    case 'MET_DOUBLE'
        type = 'double';
    otherwise
        error('Unknown element type in metaimage header: %s', string);
end

function byteOrder = determineByteOrder(info)
% Return a character that can be used by fread function

% default byte order given by system
byteOrder = 'n';

% first check the ElementByteOrderMSB field
if isfield(info, 'ElementByteOrderMSB')
    if info.ElementByteOrderMSB
        byteOrder = 'b';
    else
        byteOrder = 'l';
    end
end

% also check the BinaryDataByteOrderMSB field
if isfield(info, 'BinaryDataByteOrderMSB')
    if info.BinaryDataByteOrderMSB
        byteOrder = 'b';
    else
        byteOrder = 'l';
    end
end
