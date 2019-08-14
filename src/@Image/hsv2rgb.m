function rgb = hsv2rgb(obj)
% Convert an image with 3 HSV channels to color RGB image.
%
%   RGB = hsv2rgb(HSV)
%
%   Example
%     HSV = rgb2hsv(Image.read('peppers.png'));
%     figure; show(HSV)
%     RGB = hsv2rgb(HSV);
%     figure; show(RGB)
%
%   See also
%     rgb2hsv, createRGB, rgb2gray
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-09-29,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.

if obj.DataSize(4) ~= 3
    error('hsv2rgb can only be applied to RGB images');
end

nd = ndims(obj);
if nd == 2 && obj.DataSize(5) == 1
    % case of planar images: simple call to matlab function
    data = permute(hsv2rgb(squeeze(obj.Data)), [1 2 4 3]);
    
else
    % case of 3D and/or movie images: iterate over dimensions 3 and 5
    data = zeros(obj.dataSize);
    for z = 1:obj.dataSize(3)
        for t = 1:obj.dataSize(5)
            data(:,:,z,:,t) = squeeze(hsv2rgb(obj.Data(:,:,z,:,t)));
        end
    end
    
end

% create result image
rgb = Image('data', data, 'parent', obj);