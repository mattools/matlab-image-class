function HSV = rgb2hsv(obj)
% Convert RGB color image to HSV color image.
%
%   output = rgb2hsv(input)
%
%   Example
%      img = Image.read('peppers.png');
%      hsv = rgb2hsv(img);
%      figure; show(hsv); 
%
%   See also
%     createRGB, hsv2rgb, rgb2gray
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if obj.DataSize(4) ~= 3
    error('rgb2hsv can be applied only to RGB images');
end

nd = ndims(obj);
if nd == 2 && obj.DataSize(5) == 1
    % case of planar images: simple call to matlab function
    data = permute(rgb2hsv(squeeze(obj.Data)), [1 2 4 3]);
    
else
    % case of 3D and/or movie images: iterate over dimensions 3 and 5
    data = zeros(obj.DataSize);
    for z = 1:obj.DataSize(3)
        for t = 1:obj.DataSize(5)
            data(:,:,z,:,t) = squeeze(rgb2hsv(obj.Data(:,:,z,:,t)));
        end
    end
    
end

% create result image
name = createNewName(obj, '%s-hsv');
HSV = Image('Data', data, 'Parent', obj, 'Name', name);
