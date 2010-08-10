function img = metaImageRead(info)
%METAIMAGEREAD  Read an image in MetaImage format
%   output = metaImageRead(input)
%
%   Example
%   info = metaImageInfo('example.hdr');
%   X = metaImageRead(info);
%
%   TODO: add support for multiple image files
%
%   See also
%   metaImageInfo, readstack, analyze75info
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-01-27,    using Matlab 7.9.0.529 (R2009b)
% http://www.pfl-cepia.inra.fr/index.php?page=slicer
% Copyright 2010 INRA - Cepia Software Platform.

% info should be a structure. If not, assume this is name of info file
if ~isstruct(info)
    if ischar(info)
        info = metaImageInfo(info);
    else
        error('First argument must be a metaimage info structure');
    end
end

% open data file
f = fopen(info.ElementDataFile, 'rb');
if f==-1
    error(['Unable to open data file: ' info.ElementDataFile]);
end

% determines pixel type
[pixelType isArrayType] = parseMetaType(info.ElementType);

% in the case of array type, need number of channels
nChannels = 1;
if isArrayType
    nChannels = info.ElementNumberOfChannels;
end

% skip header
fread(f, info.HeaderSize*nChannels, ['*' pixelType]);

% compute size of resulting array
% (in the case of multi-channel image, use dim=3 for channel dimension).
dims = info.DimSize;
if isArrayType
    dims = [nChannels dims];
end

% allocate memory for data
img = zeros(dims, pixelType);

% Specify little- or big-endian ordering
byteOrder = determineByteOrder(info);

% read data
img(:) = fread(f, prod(dims), ['*' pixelType], byteOrder);

% convert order of elements
if isArrayType
    % for color images, replace channel dim at third position
    img = permute(img, [3 2 1 4:length(dims)]);
else
    % permute dims 1 and 2
    img = permute(img, [2 1 3:length(dims)]);
end

% close file
fclose(f);


function [type isArray] = parseMetaType(string)

% determines if the data type is an array or a scalar
isArray = false;
ind = findstr(string, '_ARRAY');
if ~isempty(ind)
    isArray = true;
    string = string(1:ind-1);
end

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
