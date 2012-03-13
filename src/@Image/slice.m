function res = slice(this, dir, index)
%SLICE Extract a slice from a 3D image
%
%   S = slice(IMG, DIR, INDEX)
%   DIR is 1, 2 or 3 for x, y or z direction respectively, and INDEX is the
%   slice index, 1-indexed, between 1 and size(IMG, DIR).
%
%   The result SLICE is a 3D Image, with the dimension DIR having only one
%   element. Use the "squeeze" method to convert to a 2D image.
%
%   Example
%     % extract a slice approximately in the middle of the brain
%     img = Image.read(analyze75info('brainMRI.hdr'));
%     sli = slice(img, 3, 13);
%     sli = squeeze(sli);
%     show(sli);
%
%   See also
%   squeeze
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% parse axis, and check bounds
dir = parseAxisIndex(dir);

% ndims = length(size(this.data));
switch dir
    case 1
        % x-slice: rows Z, cols Y
        res = Image('data', this.data(index,:,:,:,:), 'dimension', 3, 'parent', this);
    case 2
        % y-slice: rows Z, cols X
        res = Image('data', this.data(:,index,:,:,:), 'dimension', 3, 'parent', this);
    case 3
        % Z-slice: rows Y, cols X
        res = Image('data', this.data(:,:,index,:,:), 'dimension', 3, 'parent', this);
    otherwise
        error('should specify direction between 1 and 3');
end

