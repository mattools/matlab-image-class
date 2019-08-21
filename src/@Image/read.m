function img = read(fileName, varargin)
% Read an image from a file.
%
%   IMG = Image.read(FILENAME)
%   Read an image from the specified file name.
%
%   IMG = Image.read(FILENAME, 'format', FMT)
%   Forces the format. Available formats are:
%   * all the formats recognized by the imread function
%   * analyze
%   * dicom
%   * metaimage
%
%   Example
%   % read a grayscale image
%   img = Image.read('cameraman.tif');
%
%   % read a color image
%   img = Image.read('peppers.png');
%
%   % read a 3D image
%   img = Image.read('brainMRI.hdr');
%
%   See also
%     imread, readSeries, write
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract filename's extension
[path, name, ext] = fileparts(fileName); %#ok<ASGLU>

% try to deduce format from extension
if strcmpi(ext, '.hdr')
    format = 'analyze';
elseif strcmpi(ext, '.dcm')
    format = 'dicom';
elseif strcmpi(ext, '.mhd')
    format = 'metaimage';
else
    format = ext(2:end);
end

% parse optional arguments
while length(varargin) > 1
    pname = varargin{1};
    if strcmpi(pname, 'format')
        format = varargin{2};
    else
        warning(['Unknown optional argument: ' pname]);
    end
    varargin(1,2) = [];
end

% Process image reading depending on the format
if strcmpi(format, 'analyze')
    % read image in Mayo's Analyze Format
    info = analyze75info(fileName);
    data = analyze75read(info);
    img = Image(data);
    
elseif strcmpi(format, 'metaimage')
    % read image in MetaImage format
    img = readMetaImage(fileName);
    
elseif strcmpi(format, 'dicom')
    % read image in DICOM format
    info = dicominfo(fileName);
    data = dicomread(info);
    img = Image(data);
    
elseif strcmpi(format, 'tif')
    % special handling of tif files that can contain 3D images
    infoList = imfinfo(fileName);
    read3d = false;
    if length(infoList) > 1 
        if infoList(1).Width == infoList(end).Width && infoList(1).Height == infoList(end).Height 
            read3d = true;
        end
    end
    
    if read3d
        % read first image to initialize 3D image
        img1 = Image(imread(fileName, 1));
        dim = [infoList(1).Width infoList(2).Height length(infoList)];
        img = Image.create(dim, class(img1.Data));
        
        % iterate over slices
        for i = 1:length(infoList)
            img.Data(:,:,i,:) = permute(imread(fileName, i), [2 1 3]);
        end
    else
        % For 2D images, use standard Matlab functions
        img = Image(imread(fileName));
    end
else
    % otherwise, assumes format can be managed by Matlab Image Processing
    data = imread(fileName);
    img = Image(data);
end

img.Name = [name ext];


function img = readMetaImage(fileName)
% read image in MetaImage format

% read info file and data
info = metaImageInfo(fileName);
data = readMetaImageData(info);
img = Image.create('data', data);

% setup spatial calibration
if isfield(info, 'Offset')
    img.Origin = info.Offset;
end
if isfield(info, 'ElementSize')
    img.Spacing = info.ElementSpacing;
end
if isfield(info, 'ElementSpacing')
    img.Spacing = info.ElementSpacing;
end
