function count = getElementNumber(this)
%GETELEMENTNUMBER  Count the total number of elements (pixels or voxels)
%
%   COUNT = getElementNumber(IMG)
%   COUNT = IMG.getElementNumber(IMG)
%
%   Example
%     % number of pixels of a grayscale image
%     img = Image.read('cameraman.tif');
%     img.getElementNumber
%     ans =
%         65536
%     % equal to 256*256
%
%     % number of pixels of a color image
%     img = Image.read('peppers.png');
%     img.getElementNumber
%     ans = 
%         196608
%     % equal to 512*384
%
%     % number of elements of a 3D grayscale image
%     img = Image.read('brainMRI.hdr');
%     img.getElementNumber
%     ans =
%         442368
%     % equal to 128*128*27
%
%   See also
%   histogram
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

dim = getSize(this);
count = prod(dim);
