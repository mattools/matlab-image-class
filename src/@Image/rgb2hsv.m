function HSV = rgb2hsv(this)
%RGB2HSV Convert RGB color image to HSV color image
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

if this.dataSize(4) ~= 3
    error('rgb2hsv can be applied only to RGB images');
end

nd = ndims(this);
if nd == 2 && this.dataSize(5) == 1
    % case of planar images: simple call to matlab function
    data = permute(rgb2hsv(squeeze(this.data)), [1 2 4 3]);
    
else
    % case of 3D and/or movie images: iterate over dimensions 3 and 5
    data = zeros(this.dataSize);
    for z = 1:this.dataSize(3)
        for t = 1:this.dataSize(5)
            data(:,:,z,:,t) = squeeze(rgb2hsv(this.data(:,:,z,:,t)));
        end
    end
    
end

% create result image
HSV = Image('data', data, 'parent', this);
