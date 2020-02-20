function b = isTimeLapseImage(obj)
% Checks if an image has a time dimension.
%
%   B = isTimeLapseImage(IMG)
%
%   Example
%     img = Image.read('cameraman.tif');
%     isTimeLapseImage(img);
%     ans =
%         0
%
%     % read a time-lapse image
%     img = Image.read('xylophone.mp4');
%     isTimeLapseImage(img)
%     ans =
%        logical
%         1
%
%
%   See also
%     isPlanarImage, is3dImage, ndims, size
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-02-20,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRAE - Cepia Software Platform.

b = obj.DataSize(5) > 1;
