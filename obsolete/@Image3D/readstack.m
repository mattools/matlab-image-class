function img = readstack(fname, varargin)
%READSTACK Read either a list of 2D images (slices), or a 3D image
%
%   Syntax
%   IMG = readstack(FNAME)
%   IMG = readstack(FNAME, INDICES)
%   IMG = readstack(FNAME, TYPE, DIM)
%   IMG = readstack(..., 'verbose')
%   IMG = readstack(..., 'quiet')
%
%   Description
%
%   IMG = readstack(FNAME)
%   FNAME is the base name of the image.
%   In the case of a bundle image, this is simply the name of the file.
%   In the case of an image stored as several slices, this is the string
%   common to each file with wildcard '#', '?' or '0' at the position of
%   the slices indices.
%   IMG is a 3-dimensional array of type uint8, size: X*Y*Z;
%    or a 4 dimensional array for color images (X*Y*3*Z).
%
%   IMG = readstack(FNAME, INDICES)
%   forces the number of dimensions of resulting array (slices images)
%   FNAME: base filename of images, without end number (string)
%   INDICES: indices of images to put for result. Ex:  [0:39]
%
%   IMG = readstack(FNAME, TYPE, DIM)
%   forces the type and number of dimensions of resulting array.
%   FNAME: name of the single stack file
%   TYPE:  matlab type of data ('uint8', 'double'...)
%   DIM:   size of final stack. Ex : [256 256 50].
%   There is no support for binary raw stacks.
%
%   IMG = readstack(..., 'verbose')
%   gives some information on the files 
%
%   IMG = readstack(..., 'quiet')
%   does not display anything. This is the default mode.
%
%   Examples:
%   IMG = readstack('images???.tif');
%   IMG = readstack('aStack.tif');
%   IMG = readstack('files00.bmp');
%   IMG = readstack('files00.bmp', 5:23);
%   IMG = readstack('files00slices##.tif');
%   IMG = readstack('rawData.raw', 'uint8', [256 256 50]);
%
%   See also:
%   savestack, imread
%
%   ---------
%   author: David Legland, david.legland(at)grignon.inra.fr
%   INRA - Cepia Software Platform
%   created the 10/09/2003.
%   http://www.pfl-cepia.inra.fr/index.php?page=slicer
%   Licensed under the terms of the new BSD license, see file license.txt

% select 'verbose' or 'silent' option  ----------------

% verbose by default
verbose = 0;

% check each input argument
for i=1:length(varargin)
    var = varargin{i};
    if ~ischar(var)
        continue;
    end
    
    % check the verbose option, and remove it from input variables
    if strcmp(var, 'verbose')
        verbose = 1;
        t = 1:length(varargin);
        varargin = varargin(t(t~=i));
        break;
    end

    % check the silent option, and remove it from input variables
    if strcmp(var, 'silent') || strcmp(var, 'quiet')
        verbose = 0;
        t = 1:length(varargin);
        varargin = varargin(t(t~=i));
        break;
    end
end

%% import a raw file. 
% First argument is type of image ('uint8' usually), 
% and second argument contains size of image to load.
if length(varargin)>1
    type = varargin{1};
    dim = varargin{2};
    
    img = zeros(dim, type);
    f = fopen(fname, 'r');
    img(:) = fread(f, dim(1)*dim(2)*dim(3), ['*' type]);
    
    return;
end

% check if image stored in one bubndle file or as several stacks
bundle =  sum(ismember('#?', fname))==0;
if exist(fname, 'file')
    bundle = length(imfinfo(fname))>1;
end

if ~bundle    
    % images stored in several 2D files ------------------------
    % -> need to know numbers of slices to read.
        
    %% Compute the base name of the image, by removing '#', '?' or '0'
    
    % characters to replace with numbers
    chars = '#?0';
    
    index = [];    
    for c=1:length(chars)
        % identify number of chars in file name
        n=5;
        while isempty(index) && n>1
            n = n-1;
            index = strfind(fname, repmat(chars(c), [1 n]));
        end

        % escape if special characters has been found
        if  ~isempty(index)
            break;
        end
    end
    
    % In the case of several '00' parts, consider only the last one 
    index = index(length(index));
        
    % create file basename and endname
	len = length(fname);
    basename = fname(1:index-1);
    endname = fname(index+n:len);

    
    %% compute indices of slices to read
    
    if ~isempty(varargin)
        % slice indices are given as parameters
        range=varargin{1};
    else            
        % identify slices to read by detecting last index of slices
        i=0;
        while true
            % check existence of file for given index
            imgname = sprintf(['%s' sprintf('%%0%dd', n) '%s'], basename, i, endname);
            if ~exist(imgname, 'file')
                break;
            end
            i = i+1;
        end
        % read slices from the first one to the last existing one
        range = 0:i-1;
    end
    if verbose
        disp(sprintf('read slices from %d to %d', range(1), range(end)));
    end
    
    %% Read each slice of the image
    
    % read slice for each range index
    string = [basename sprintf('%%0%dd', n)  endname];
    
    % adapt filename format to windows if needed
    if ispc
        string = strrep(string, '\', '\\');
    end    
    
    % read the first image
    img = imread(sprintf(string, range(1)));
    
    % read each image one after the other
    if length(size(img))==2
        % allocate memory
        img(1, 1, length(range))=0;
        
        % read each gray scale image successively
        for i=2:length(range)
            img(:,:,i) = imread(sprintf(string, range(i)));
        end
    else
        % pre-allocate memory
        img(1, 1, 1, length(range))=0;
        
        % read each color image successively
        for i=2:length(range)
            img(:,:,:,i) = imread(sprintf(string, range(i)));
        end
    end
    
else
    % Image stored in one bundle file --------------------------
    
    % get image dimensions
    info = imfinfo(fname);
    
    % If input argument is found, it is used as the number of slices to
    % read. Anyway, read all the slices.
    range = 1:length(info);
    if ~isempty(varargin)
        range = varargin{1};
    end

    if verbose
        disp(sprintf('read %d slices in a stack', length(range)));
    end
    
    % read each slice of the 3D image
    img = imread(fname, range(1));
    
    if length(size(img))==2         % read gray scale images -----        
        % pre-allocate memory
        img(1, 1, length(range)) = 0;
        
        % add each slice successively
        for i=2:length(range)
            img(:,:,i) = imread(fname, range(i));
        end
    else                            % read color images      -----
        % pre-allocate memory
        img(1, 1, 1, length(range)) = 0;
        
        % add each slice successively
        for i=2:length(range)
            img(:,:,:,i) = imread(fname, range(i));
        end
    end 
end
