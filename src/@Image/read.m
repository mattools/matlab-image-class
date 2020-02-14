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
if strcmpi(format, 'analyze')
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
        % (see also the 'readstack' function in private directory)
        % read first image to initialize 3D image
        img1 = Image(imread(fileName, 1));
        dim = [infoList(1).Width infoList(2).Height length(infoList)];
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
else
    % otherwise, assumes format can be managed by Matlab Image Processing
    data = imread(fileName);
    img = Image(data);
end

% populate additional meta-data
img.Name = name;
img.FilePath = fileName;
