function img = read(fileName, varargin)
%READ Read an image from a file
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
%   imread, readSeries, write
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract filename's extension
[path, name, ext] = fileparts(fileName); %#ok<ASGLU>

% try to deduce format from extension
format = ext;
if strcmpi(ext, '.hdr')
    format = 'analyze';
elseif strcmpi(ext, '.dcm')
    format = 'dicom';
elseif strcmpi(ext, '.mhd')
    format = 'metaimage';
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
    
else
    % otherwise, assumes format can be managed by Matlab Image Processing
    data = imread(fileName);
    
    %     vector = false;
    %     if size(data, 3) == 3
    %         vector = true;
    %     end
    img = Image(data);
end

img.name = [name ext];


function img = readMetaImage(fileName)
% read image in MetaImage format

% read info file and data
info = metaImageInfo(fileName);
data = readMetaImageData(info);
img = Image.create('data', data);

% setup spatial calibration
if isfield(info, 'Offset')
    img.origin = info.Offset;
end
if isfield(info, 'ElementSize')
    img.spacing = info.ElementSpacing;
end
if isfield(info, 'ElementSpacing')
    img.spacing = info.ElementSpacing;
end
