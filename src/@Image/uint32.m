function res = uint32(this)
%Convert an image to a uint32 matrix
%   
%   res = uint32(img1);
%
%   Example
%   img = Image2D('cameraman.tif');
%   dat = uint32(img);
%   imshow(dat);
%
%   See also
%   Image/getBuffer
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

dims = this.dataSize;
res = uint32(permute(this.data, [2 1 3:length(dims)]));