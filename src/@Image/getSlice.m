function slice = getSlice(this, dir, index)
%GETSLICE Extract a slice from a 3D image
%
%   SLICE = this.getSlice(DIR, INDEX)
%   DIR is 1, 2 or 3 for x, y or z direction respectively, and INDEX is the
%   slice index, 1-indexed, between 1 and getSize(img, DIR).
%   The result SLICE is a matlab array.
%
%   Example
%   % extract a slice approximately in the middle of the brain
%   I = analyze75read(analyze75info('brainMRI.hdr'));
%   img = Image3D(I);
%   slice = img.getSlice(3, 13);
%   imshow(slice);
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%TODO: decide if we return an array or a 2D image in 3D space.

% parse axis, and check bounds
dir = Image.parseAxisIndex(dir);

ndims = length(size(this.data));
if ndims==3
    % Case of gray scale images
    switch dir
        case 1
            % x-slice: rows Z, cols Y
            slice = permute(this.data(index, :, :), [3 2 1]);
        case 2
            % y-slice: rows Z, cols X
            slice = permute(this.data(:, index, :), [3 1 2]);
        case 3
            % Z-slice: rows Y, cols X
            slice = this.data(:, :, index)';
        otherwise
            error('should specify direction between 1 and 3');
    end
else
    % Case of color images: slice the volume, and keep the channel
    % component as last one.
    switch dir
        case 1
            % x-slice: rows Z, cols Y
            slice = permute(this.data(index, :, :, :), [4 2 3 1]);
        case 2
            % y-slice: rows Z, cols X
            slice = permute(this.data(:, index, :, :), [4 1 3 2]);
        case 3
            %  Z-slice: rows Y, cols X
            slice = permute(this.data(:, :, :, index), [2 1 3 4]);
        otherwise
            error('should specify direction between 1 and 3');
    end
end
