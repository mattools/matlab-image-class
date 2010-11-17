function img = read(fileName, varargin)
%READ Read an image from a file
%
%   IMG = Image.read(FILENAME)
%
%   Example
%   img = Image.read('cameraman.tif');
%
%   See also
%   Image2D/read, Image3D/read, imread
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% extract filename's extension
[path, name, ext] = fileparts(fileName); %#ok<ASGLU>

% try to deduce format from extension
format = ext;
if strmatch(ext, '.hdr')
    format = 'analyze';
elseif strmatch(ext, '.dcm')
    format = 'dicom';
elseif strmatch(ext, '.mhd')
    format = 'metaimage';
end

% Process image reading depending on the format
if strmatch(format, 'analyze')
    % read image in Mayo's Analyze Format
    info = analyze75info(fileName);
    data = analyze75read(info);
    img = Image.create(data);
    
elseif strmatch(format, 'metaimage')
    % read image in MetaImage format
    img = readMetaImage(fileName);
    
elseif strmatch(format, 'dicom')
    % read image in DICOM format
    info = dicominfo(fileName);
    data = dicomread(info);
    img = Image.create(data);
    
else
    % otherwise, assumes format can be managed by Matlab Image Processing
    data = imread(fileName);
    
    vector = false;
    if size(data, 3)==3
        vector = true;
    end
    img = Image.create(data, 'vector', vector);
end


function img = readMetaImage(fileName)
% read image in MetaImage format

% read info file and data
info = metaImageInfo(fileName);
data = metaImageRead(info);
img = Image.create(data);

% setup spatial calibration
calib = img.getSpatialCalibration();
if isfield(info, 'Offset')
    calib.origin = info.Offset;
    calib.calibrated = true;
end
if isfield(info, 'ElementSize')
    calib.spacing = info.ElementSize;
    calib.calibrated = true;
end
if isfield(info, 'ElementSpacing')
    calib.spacing = info.ElementSpacing;
    calib.calibrated = true;
end
img.setSpatialCalibration(calib);

[path name] = fileparts(fileName); %#ok<ASGLU>
img.name = name;
