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
%   slice = slice.squeeze();
%   slice.show();
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% parse axis, and check bounds
dir = Image.parseAxisIndex(dir);

% ndims = length(size(this.data));
% if ndims==3
switch dir
    case 1
        % x-slice: rows Z, cols Y
        %slice = permute(this.data(index, :, :), [3 2 1]);
        slice = Image(3, 'data', this.data(index, :, :), 'parent', this);
    case 2
        % y-slice: rows Z, cols X
        %slice = permute(this.data(:, index, :), [3 1 2]);
        slice = Image(3, 'data', this.data(:, index, :), 'parent', this);
    case 3
        % Z-slice: rows Y, cols X
        % slice = this.data(:, :, index)';
        slice = Image(3, 'data', this.data(:, :, index), 'parent', this);
    otherwise
        error('should specify direction between 1 and 3');
end
% else
%     % Case of color images: slice the volume, and keep the channel
%     % component as last one.
%     switch dir
%         case 1
%             % x-slice: rows Z, cols Y
%             slice = permute(this.data(index, :, :, :), [3 2 4 1]);
%         case 2
%             % y-slice: rows Z, cols X
%             slice = permute(this.data(:, index, :, :), [3 1 4 2]);
%         case 3
%             %  Z-slice: rows Y, cols X
%             slice = permute(this.data(:, :, index, :), [2 1 4 3]);
%         otherwise
%             error('should specify direction between 1 and 3');
%     end
% end
