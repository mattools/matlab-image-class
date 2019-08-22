function [img, info] = readVgiStack(fileName, varargin)
% Read a 3D stack stored in VGI format.
%
%   IMG = readVgiStack(FILENAME)
%
%   Example
%   readVgiStack
%
%   See also
%     readMetaImage, readVgiStackInfo
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-10-18,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2018 INRA - Cepia Software Platform.

%% Initialisations

% parse optional input arguments
verbose = false;
while length(varargin) >= 2
    name = varargin{1};
    if strcmp(name, 'verbose')
        verbose = varargin{2};
    end
    varargin(1:2) = [];
end


%% Read File info

% read raw info
info = readVgiStackInfo(fileName, 'verbose', verbose);

% read file in same directory as information file.
[baseDir, tmp] = fileparts(fileName); %#ok<ASGLU>
[tmp, fileName, ext] = fileparts(info.DataFileName); %#ok<ASGLU>
filePath = fullfile(baseDir, [fileName ext]);
info.DataFileName = filePath;


%% Read binary data

% open for for binary reading
f = fopen(filePath, 'rb');
if f == -1
    error(['Unable to open data file: ' info.DataFileName]);
end

% assume little endian is default
byteOrder = 'l';

% read binary data
if verbose
    disp('allocate memory');
end
dims = [info.SizeX info.SizeY info.SizeZ];
pixelType = 'uint16';
imageData = zeros(dims, pixelType);


if verbose
    fprintf('read data...');
end
tic;
imageData(:) = fread(f, prod(dims), ['*' pixelType], byteOrder);
t = toc;
if verbose
    fprintf(' (%7.3f s)\n', t);
end


% close file
fclose(f);

% permute dims 1 and 2
if verbose
    disp('permute');
end

% create new image
img = Image('data', imageData);

