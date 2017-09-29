function rgb = hsv2rgb(this)
%HSV2RGB Convert an image with 3 HSV channels to color RGB image
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
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-09-29,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.

if this.dataSize(4) ~= 3
    error('hsv2rgb can only be applied to RGB images');
end

nd = ndims(this);
if nd == 2 && this.dataSize(5) == 1
    % case of planar images: simple call to matlab function
    data = permute(hsv2rgb(squeeze(this.data)), [1 2 4 3]);
    
else
    % case of 3D and/or movie images: iterate over dimensions 3 and 5
    data = zeros(this.dataSize);
    for z = 1:this.dataSize(3)
        for t = 1:this.dataSize(5)
            data(:,:,z,:,t) = squeeze(hsv2rgb(this.data(:,:,z,:,t)));
        end
    end
    
end

% create result image
rgb = Image('data', data, 'parent', this);