function res = getSlice(this, dir, index)
%GETSLICE Extract a slice from a 3D vector image
%
%   SLICE = this.getSlice(DIR, INDEX)
%   DIR is 1, 2 or 3 for x, y or z direction respectively, and INDEX is the
%   slice index, 1-indexed, between 1 and getSize(img, DIR).
%   The result SLICE is a 2D vector image.
%
%   Example
%   % extract a slice approximately in the middle of the brain
%   I = analyze75read(analyze75info('brainMRI.hdr'));
%   img = Image3D(I);
%   grad = img.gradient();
%   slice = grad.getSlice(3, 13);
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

% Case of gray scale images
switch dir
    case 1
        % x-slice: rows Z, cols Y
        slice = permute(this.data(index, :, :, :), [3 2 4 1]);
    case 2
        % y-slice: rows Z, cols X
        slice = permute(this.data(:, index, :), [3 1 4 2]);
    case 3
        % Z-slice: rows Y, cols X
        slice = permute(this.data(:, :, index, :), [1 2 4 3]);
    otherwise
        error('should specify direction between 1 and 3');
end

res = VectorImage2D(slice, 'parent', this);
