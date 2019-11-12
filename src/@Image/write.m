function write(obj, fileName, varargin)
% Write image data into specified file.
%
%   write(IMG, FILENAME)
%
%   Example
%     % read a color image and write a new image
%     img = Image.read('peppers.png');
%     img2 = flip(img, 1);
%     write(img2, 'colorImage.tif');
%   
%     % read a 3D image and save as multi-page tiff
%     img = Image.read('brainMRI.hdr');
%     write(img, 'img3d.tif');
%     img2 = Image.read('img3d.tif');
%
%   See also
%     Image/read
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

nd = obj.Dimension;
if nd == 2
    % assumes format can be managed by Matlab Image Processing
    imwrite(permute(obj.Data, [2 1 4 3 5]), fileName, varargin{:});
    
elseif nd == 3
    % try to save a 3D image
    
    % first determines file format
    [path, baseName, ext] = fileparts(fileName); %#ok<ASGLU>
    
    if strcmp(ext, '.tif')
        writeTiffStack(obj, fileName);
    else
        error('Unable to save 3D images to file format: %s', ext);
    end
else
    error('Can not write image with dimension: %d', nd);
end

end

%% WriteTiffStack

function writeTiffStack(obj, fileName)
% Save a 3D image into a multi-page tiff file.
%
% Uses the TIFF library from Matlab.
 
% setup TIFF tags shared by all images
tagStruct.ImageWidth = size(obj, 1);
tagStruct.ImageLength = size(obj, 2);

isGrayscale = isGrayscaleImage(obj);

if isa(obj.Data, 'uint8')
    tagStruct.BitsPerSample = 8;
elseif isa(obj.Data, 'uint16')
    tagStruct.BitsPerSample = 16;
else
    error(['Can not manage image data with class: ' class(obj.Data)]);
end

if isGrayscale
    tagStruct.SamplesPerPixel = 1;
    tagStruct.Photometric = Tiff.Photometric.MinIsBlack;
else
    tagStruct.SamplesPerPixel = 3;
    tagStruct.Photometric = Tiff.Photometric.RGB;
end

tagStruct.Compression = Tiff.Compression.PackBits;
tagStruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagStruct.Software = 'Matlab_ImageClass';

% create a TIFF file, and setup necessary tags
t = Tiff(fileName, 'w');
setTag(t, tagStruct);

nSlices = obj.DataSize(3);
if isGrayscale
    % save a grayscale stack
    
    % write first slice
    write(t, obj.Data(:,:,1)');
    
    % append other slices
    for i = 2:nSlices
        writeDirectory(t);
        setTag(t, tagStruct);
        write(t, obj.Data(:,:,i)');
    end
    
else
    % save a color stack
    
    % write first slice
    write(t, permute(obj.Data(:,:,:,1), [2 1 3 4]));
    
    % append other slices
    for i = 2:nSlices
        writeDirectory(t);
        setTag(t, tagStruct);
        write(t, permute(obj.Data(:,:,:,i), [2 1 3 4]));
    end
end

close(t);
end
