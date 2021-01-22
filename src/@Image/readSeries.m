function img = readSeries(fileName, varargin)
% Read a series of 2D images as a 3D image.
%
%   Syntax:
%   IMG = Image.readSeries(PATTERN);
%   Read all images that match the specified file pattern, and concatenate
%   them as a 3D image.
%
%   IMG = Image.readSeries(PATTERN, INDS);
%   Specifies the index of the images to read.
%
%   IMG = Image.readSeries(..., 'dim', CATDIM);
%   Specifies the concatenation dimension. CATDIM can be 3 (resulting in 3D
%   images), 4 (resulting in vector images) or 5 (resulting in time-lapse
%   images)
%
%   IMG = Image.readSeries(..., 'verbose', true);
%   gives some information on the reading process. 
%
%   Example
%     % Read the first ten TIFF images in current directoty and concatenate
%     % them into a 3D image.
%     img = Image.readSeries('*.tif', 1:10);
%
%   See also
%     read, importRaw, zeros, cat
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-06-09,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - Cepia Software Platform.

%% Parse input options

% index of images to read (empty -> read all images)
range = [];

% the dimension to concatenate. Can be 3 for z stacks, 4 for multi-channel
% images, or 5 for time-lapse images.
catDim = 3;

% verbose by default
verbose = 0;

% index of images to read (empty -> read all images)
if nargin > 1 && isnumeric(varargin{1})
    range = varargin{1};
    varargin(1) = [];
end

% check each input argument
while length(varargin) > 1
    pname = varargin{1};
    pvalue = varargin{2};
    
    if strcmpi(pname, 'verbose')
        verbose = pvalue;
    elseif strcmpi(pname, 'range')
        range = pvalue;
    elseif strcmpi(pname, 'dim')
        catDim = pvalue;
        if catDim < 3 || catDim > 5
            error('Concatenation dimension must be comprised between 3 and 5');
        end
    else
        error(['Unknown argument name: ' pname]);
    end
    varargin(1:2) = [];
end


%% Read the list of files
% -> need to know numbers of slices to read.

[path, name, ext] = fileparts(fileName);

fileList = dir(fullfile(path, [name ext]));
if length(fileList) == 1
    name = '*';
    fileList = dir(path, [name ext]);
end    

% default range
if isempty(range)
    range = 1:length(fileList);
end

if verbose
    msg = sprintf('read slices from %d to %d', range(1), range(end));
    disp(msg); %#ok<DSPS>
end


%% Allocate memory

% read first image to know its dimensions
img0 = Image.read(fullfile(path, fileList(range(1)).name));

% compute result dimensions
dim0 = size(img0);
dims = [dim0(1:2) ones(1, catDim-3) 0];
subs = struct('type', '()', 'subs', {{':', ':', 1, 1, 1}});

% create result array
if channelCount(img0) == 1
    data = zeros(dims, 'like', img0.Data);
else
    dims(4) = channelCount(img0);
    data = zeros(dims, 'like', img0.Data);
    subs.subs{4} = ':';
end

% fill in first image
data = subsasgn(data, subs, img0.Data);


%% Read image data

% Read each slice of the image
for iSlice = 2:length(range)
    img = Image.read(fullfile(path, fileList(range(iSlice)).name));
    subs.subs{catDim} = iSlice;
    data = subsasgn(data, subs, img.Data);
end

% create image
img = Image('data', data, 'parent', img0);


%% Setup meta-data

% file name
fileName = fileList(range(1)).name;
img.Name = fileName;
img.FilePath = fullfile(path, fileName);

% in case of vector image, populate channel names
if catDim == 4
    img.ChannelNames = {fileList(range).name};
end
