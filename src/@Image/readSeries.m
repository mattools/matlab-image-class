function img = readSeries(fileName, varargin)
% Read a series of 2D images as a 3D image.
%
%   Syntax:
%   IMG = Image.readSeries(FILEPATH);
%   IMG = Image.readSeries(FILEPATH, 'range', INDS);
%
%   IMG = Image.readSeries(..., 'verbose, true);
%   gives some information on the files 
%
%
%   See also
%     read
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-06-09,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - Cepia Software Platform.

%% Parse input options

% index of images to read (empty -> read all images)
range = [];

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
    else
        error(['Unknown argument name: ' pname]);
    end
    varargin(1:2) = [];
end


%% Read images stored in several 2D files
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


%% read first slice to allocate memory

img0 = Image.read(fullfile(path, fileList(range(1)).name));

% create result array
dim0 = size(img0);
dim = [dim0(1:2) length(range)];
if channelCount(img0) > 1
    dim = [dim channelCount(img0)];
end
data = zeros(dim, 'like', img0.Data);

% fill in first slice
data(:,:,1,1) = img0.Data;

%% Read each slice of the image

for iSlice = 2:length(range)
    img = Image.read(fullfile(path, fileList(range(iSlice)).name));
    data(:,:,iSlice, :) = img.Data;
end

img = Image('data', data, 'parent', img0);

% populate additional meta-data
img.Name = name;
img.FilePath = fileName;
