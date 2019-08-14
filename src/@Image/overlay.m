function res = overlay(obj, varargin)
% Add colored markers to an image (2D or 3D, grayscale or color).
%
%   Usage
%   OVR = overlay(IMG, MASK);
%   OVR = overlay(IMG, MASK, COLOR);
%   OVR = overlay(IMG, MASK1, COLOR1, MASK2, COLOR2...);
%   OVR = overlay(IMG, RED, GREEN, BLUE);
%   
%   Description
%   OVR = overlay(IMG, MASK);
%   where IMG and MASK are 2 images the same size, returns the image BASE
%   with red markers given by MASK superposed on it.
%   IMG can be either color or gray-scale image, 2D or 3D (actually
%   Ny*Nx*3*Nz in the case of 3D color image)
%   MASK is a binary image with same size as IMG 
%   OVR is a color image, the same size as the original image
%
%   OVR = overlay(IMG, MASK, COLOR);
%   assumes that binary image MASK and image BASE have the same size,
%   replace all pixels of MASK by the color COLOR. The argument COLOR is
%   either a vector with 3 elements, or a character belonging to {'r', 'g',
%   'b', 'c', 'm', 'y', 'k', 'w'}.
%
%   This syntax can be repeated:
%   OVR = overlay(IMG, MASK1, COLOR1, MASK2, COLOR2, MASK3, COLOR3)
%
%   OVR = overlay(IMG, RED, GREEN, BLUE);
%   where RED, GREEN and BLUE are binary images the same size as IMG image,
%   puts 3 overlays of different colors on the base image.
%   It is possible to specify only one overlay by using empty data:
%   OVR = overlay(BASE, [], [], BLUE);
%
%
%   Examples
%   %% the boundary overlay of a binary image
%     img = Image.read('circles.png');
%     bnd = boundary(img);
%     ovr = overlay(img, bnd);
%     figure; show(ovr);
%
%   %% Display two binary overlays on a grayscale image
%     % Read demo image and binarize it
%     img = Image.read('coins.png');
%     bin = closing(img>100, ones(3, 3));
%     % compute disc boundary
%     bnd = boundary(bin);
%     % compute inluence zone o feach disc
%     wat = watershed(distanceMap(bin), 8);
%     % compute and display overlay as 3 separate bands
%     res = overlay(img, bnd, [], wat==0);
%     figure; show(res);
%     % display result with different colors
%     res = overlay(img, bnd, 'y', wat==0, [1 0 1]);
%     figure; show(res);
%
%   %% colorize a part of a grayscale image
%     % read input grayscale image
%     img = Image.read('cameraman.tif');
%     % create a colorized version of the image (yellow = red + green)
%     yellow = Image.createRGB(img, img, []);
%     % compute binary a mask around the head of the cameraman
%     mask = Image.create(size(img), 'binary');
%     mask(80:180, 20:120) = true;
%     % compute and show the overlay
%     show(overlay(img, mask, yellow));
% 
%   %% Compute overlay on a 3D image
%     img = Image.read('brainMRI.hdr'); % read 3D data
%     se = ones([3 3 3]);
%     bin = closing(img > 0, se);       % binarize and remove small holes
%     bnd = boundary(bin);              % compute boundary
%     ovr = overlay(img*3, bnd, 'm');   % compute overlay
%     show(squeeze(getSlice(ovr, 3, 7)))  % display each slice
%
%   See also
%     Image/createRGB
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-06-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% If number of options is 1 or 3, use recursion with specific asumptions

if length(varargin) == 1
    % If only one input => obj is the mask, the color is assumed to be red
    res = overlay(obj, varargin{1}, [1 0 0]);
    return;

elseif length(varargin) == 3
    % If three inputs are given, there are supposed to be the red, green
    % and blue masks, in that order. One or two masks can be empty.
    res = Image(obj);
    if ~isempty(varargin{1})
        res = overlay(res, varargin{1}, [1 0 0]);
    end
    if ~isempty(varargin{2})
        res = overlay(res, varargin{2}, [0 1 0]);
    end
    if ~isempty(varargin{3})
        res = overlay(res, varargin{3}, [0 0 1]);
    end
    return;
end


%% Initializations

% Ensure input image has uint8 type
if isa(obj.Data, 'uint8')
    img = obj.Data;
else
    img = adjustDynamic(obj);
    img = img.Data;
end

% initialize each channel of the result image with the original image
if isColorImage(obj)
    red     = img(:,:,:,1,:);
    green   = img(:,:,:,2,:);
    blue    = img(:,:,:,3,:);
else
    red     = img;
    green   = img;
    blue    = img;
end


%% Main processing

% Recursively process input arguments
% As long as we find inputs, mask is extracted and overlaid on result image
while ~isempty(varargin)
    % First argument is the mask, second argument specifies color
    mask = varargin{1};
    if isa(mask, 'Image')
        mask = mask.Data;
    else
        % convert matlab indexing to Image class indexing
        mask = permute(mask, [2 1 3 4 5]);
    end
    [r, g, b]  = parseOverlayBands(varargin{2});
    
    varargin(1:2) = [];
    
    % type cast
    mask = uint8(mask);
        
    % update each band
    red     =   red .* uint8(mask==0) + mask .* r;
    green   = green .* uint8(mask==0) + mask .* g;
    blue    =  blue .* uint8(mask==0) + mask .* b;
end

res = Image('data', cat(4, red, green, blue), 'parent', obj, 'type', 'color');


function [r, g, b] = parseOverlayBands(color)
% determines r g and b values from argument value
%
% argument COLOR can be one of:
% * a 1*3 row vector containing rgb values between 0 and 1
% * a string containing color code
% * a grayscale image
% * a color image
%
% The result are the R, G and B values coded as uint8 between 0 and 255
%

if isa(color, 'Image')
    % if input is an Image object, extract data buffer of each channel
    r = getDataBuffer(channel(color, 1));
    g = getDataBuffer(channel(color, 2));
    b = getDataBuffer(channel(color, 3));
    
elseif ischar(color)
    % parse character to  a RGB triplet
    [r, g, b] = parseColorString(color);
    
elseif isnumeric(color)
    if size(color, 1) == 1
        % normalize color between 0 and 255
        if max(color) <= 1
            color = color * 255;
        end
        
        % extract each component
        r = color(1);
        g = color(2);
        b = color(3);
        
    else
        % otherwise, color an image given as Matlab array
        [dim, isColor, is3D] = computeImageInfo(color); %#ok<ASGLU>
        if isColor
            if is3D
                r = squeeze(color(:,:,1,:));
                g = squeeze(color(:,:,2,:));
                b = squeeze(color(:,:,3,:));
            else
                r = color(:,:,1);
                g = color(:,:,2);
                b = color(:,:,3);
            end
        else
            r = color;
            g = color;
            b = color;
        end
    end
    
else
    error('Wrong data type for specifying color');
end

            
function varargout = parseColorString(color)
% PARSECOLORSTRING Parse color character to a RGB triplet, between 0 and 1

% process special colors
if strcmp(color, 'black')
    color = 'k'; 
end

% tests the first character of the string
color = color(1);
switch color
    case 'r', r=1; g=0; b=0;
    case 'g', r=0; g=1; b=0;
    case 'b', r=0; g=0; b=1;
    case 'c', r=0; g=1; b=1;
    case 'm', r=1; g=0; b=1;
    case 'y', r=1; g=1; b=0;
    case 'k', r=0; g=0; b=0;
    case 'w', r=1; g=1; b=1;
end

% convert to uint8
r = uint8(r * 255);
g = uint8(g * 255);
b = uint8(b * 255);

% format output 
if nargout == 3
    varargout = {r, g, b};
else
    varargout = {[r g b]};
end

function [dim, isColor, is3D] = computeImageInfo(img)
% Compute image size, and determines if image is 3D and/or color
% Returns the dimension of image witghout the color channel, and two binary
% flags indicating if image is color, and 3D.


% size of matlab matrix
dim0    = size(img);

% detect 3D and color image
if length(dim0) == 2
    % Default case: planar grayscale image
    dim     = dim0(1:2);
    isColor = false;
    is3D    = false;
    
elseif length(dim0) == 3
    % either 3D grayscale, or planar color image
    if dim0(3) == 3
        % third dimension equals 3 ==> color image
        dim     = dim0(1:2);
        isColor = true;
        is3D    = false;
    else
        % third dimension <> 3 ==> gray-scale 3D image
        dim     = dim0;
        isColor = false;
        is3D    = true;
    end
    
elseif length(dim0) == 4
    % 3D color image
    dim     = dim0([1 2 4]);
    isColor = true;
    is3D    = true;
    
else
    error('Unprocessed dimension');
end

