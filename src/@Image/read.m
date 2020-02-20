function img = read(fileName, varargin)
% Read an image from a file.
%
%   IMG = Image.read(FILENAME)
%   Read an image from the specified file name.
%
%   IMG = Image.read(FILENAME, 'format', FMT)
%   Forces the format. Available formats are:
%   * all the formats recognized by the imread function
%   * analyze (via the analyze75read function)
%   * dicom (via the dicomread function)
%   * metaimage (see https://itk.org/Wiki/ITK/MetaIO/Documentation#Quick_Start)
%   * VGI (used by software VGSTUDIO MAX, partial support only).
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
%   % read a time-lapse image
%   img = Image.read('xylophone.mp4');
%   isTimeLapseImage(img)
%   ans =
%      logical
%       1
%
%   See also
%     imread, readSeries, write, fileInfo
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRAE - Cepia Software Platform.

% extract filename's extension
[path, name, ext] = fileparts(fileName); %#ok<ASGLU>

% try to deduce format from extension.
% First use reader provided by Matlab then use readers in private directory.
if strcmpi(ext, '.hdr')
    format = 'analyze';
elseif strcmpi(ext, '.dcm')
    format = 'dicom';
elseif any(strcmpi(ext, {'.mhd', '.mha'}))
    format = 'metaimage';
else
    % for classical formats, simply needs to remove the initial dot.
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

% initialize the list of video file format extensions
fmtList = VideoReader.getFileFormats();
videoFormatExtensions = {fmtList.Extension};

% Process image reading depending on the format
if strcmpi(format, 'tif')
    % call the local 'read_tif' function
    img = read_tif(fileName);
    
elseif strcmpi(format, 'analyze')
    % read image in Mayo's Analyze Format
    info = analyze75info(fileName);
    data = analyze75read(info);
    img = Image(data);
    
elseif strcmpi(format, 'dicom')
    % read image in DICOM format
    info = dicominfo(fileName);
    data = dicomread(info);
    img = Image(data);
    
elseif strcmpi(format, 'metaimage')
    % read image in MetaImage format
    % (use function in "private" directory)
    img = readMetaImage(fileName);

elseif strcmpi(format, 'vgi')
    % read image in VGStudi Max format
    % (use function in "private" directory)
    img = readVgiStack(fileName);
    
elseif any(strcmp(videoFormatExtensions, format))
    % read movie by calling the local 'read_movie' function.
    img = read_movie(fileName);
    
else
    % otherwise, assumes format can be managed by Matlab Image Processing
    data = imread(fileName);
    img = Image(data);
end

% populate additional meta-data
img.Name = name;
img.FilePath = fileName;

end

function img = read_tif(fileName)
% Read image stored in a TIFF File.
%
% Can manage 3D images as well.

% check if the file contains a 3D image
infoList = imfinfo(fileName);
info1 = infoList(1);
read3d = false;
if length(infoList) > 1
    if info1.Width == infoList(end).Width && info1.Height == infoList(end).Height
        read3d = true;
    end
end

if read3d
    % read first image to initialize 3D image
    img1 = Image(imread(fileName, 1));
    dim = [info1.Width info1.Height length(infoList)];
    img = Image.create(dim, class(img1.Data));
    
    % Read all images using Tiff class
    t = Tiff(fileName, 'r');
    
    % iterate over slices
    img.Data(:,:,1,:) = permute(read(t), [2 1 3]);
    for i = 2:length(infoList)
        nextDirectory(t);
        img.Data(:,:,i,:) = permute(read(t), [2 1 3]);
    end
    close(t);
    
else
    % For 2D images, use standard Matlab functions
    img = Image(imread(fileName));
end

% Parse some Tiff Tags
if isfield(info1, 'XResolution') && ~isempty(info1.XResolution)
    img.Spacing(1) = 1.0 / info1.XResolution;
end
if isfield(info1, 'YResolution') && ~isempty(info1.YResolution)
    img.Spacing(2) = 1.0 / info1.YResolution;
end
if any(img.Spacing(1:2) ~= [1 1])
    img.Origin = zeros(size(img.Spacing));
end

% Read additional comments written by ImageJ
img = parseImageJTiffComments(img, info1);


end

function img = parseImageJTiffComments(img, info)
% Read comments written by ImageJ in the "ImageDescription" Tag

% check the tag is present
if ~isfield(info, 'ImageDescription')
    return;
end

% check the tag has content
desc = info.ImageDescription;
if isempty(desc)
    return;
end

% check description starts by 'ImageJ'
if ~strncmpi(desc, 'ImageJ=', 7)
    return;
end

% default values
nImages     = size(img, 3);
nSlices     = size(img, 3);
nChannels   = size(img, 4);
nFrames     = size(img, 5);
hyperstack	= 'false'; %#ok<NASGU>
spacing     = img.Spacing;
origin      = img.Origin;
unitName    = img.UnitName;
timeStep    = img.TimeStep;

% parse tokens in the "ImageDescription' Tag.
tokens = regexp(desc, '\n', 'split');
while ~isempty(tokens)
    if isempty(tokens{1})
        break;
    end
    
    [name, remain] = strtok( tokens{1}, '=');
    value = remain(2:end);
    
    switch lower(name)
        case {'imagej', 'hyperstack', 'mode', 'loop'}
            % nothing to do.
        case 'images'
            nImages = str2double(value);
        case 'channels'
            nChannels = str2double(value);
        case 'slices'
            nSlices = str2double(value);
        case 'frames'
            nFrames = str2double(value);
        case 'unit'
            img.UnitName = value;
        case 'spacing'
            spacing(3) = str2double(value);
            origin = [0 0 0];
        case 'finterval'
            timeStep = str2double(value);
        case {'min', 'max'}
            % nothing to do.
        otherwise
            warning(['Could not parse ImageJ comment: ' name]);
    end
    
    tokens(1) = [];
end

% check input validity
if nSlices * nChannels * nFrames ~= nImages
    warning('Z x C x T should match image number');
    return;
end

% reshape image
sizeX = size(img.Data, 1);
sizeY = size(img.Data, 2);
img = permute(reshape(img, [sizeX sizeY nChannels nSlices nFrames]), [1 2 4 3 5]);

% restore calibration data
img.Spacing = spacing;
img.Origin = origin;
img.UnitName = unitName;
img.TimeStep = timeStep;

end

function img = read_movie(fileName)
% read a movie as a 5D Image with several frames
% by converting from the VideoReader output.
reader = VideoReader(fileName);
nFrames = reader.NumFrames;
sizeX = reader.Width;
sizeY = reader.Height;
frame0 = reader.read(1);
nChannels = size(frame0, 3);
data = zeros([sizeX sizeY 1 nChannels nFrames], 'uint8');
for i = 1:nFrames
    data(:,:,:,:,i) = permute(reader.read(i), [2 1 3]);
end
img = Image('Data', data);
img.TimeStep = 1 / reader.FrameRate;
img.TimeUnit = 's';
end