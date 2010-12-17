function HSV = rgb2hsv(this)
%RGB2HSV Convert RGB color image to HSV color image
%
%   output = rgb2hsv(input)
%
%   Example
%   rgb2hsv
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-12-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

if this.dataSize(4)~=3
    error('rgb2hsv can be applied only to RGB images');
end

nd = this.getDimension();
if nd==2 && this.dataSize(5)==1
    data = permute(rgb2hsv(squeeze(this.data)), [1 2 4 3]);
    HSV = Image(2, 'data', data, 'parent', this);
    
else
    data = zeros(this.dataSize);
    for z=1:this.dataSize(3)
        for t=1:this.dataSize(5)
            data(:,:,z,:,t) = squeeze(rgb2hsv(this.data(:,:,z,:,t)));
        end
    end
    HSV = Image(nd, 'data', data, 'parent', this);
end
