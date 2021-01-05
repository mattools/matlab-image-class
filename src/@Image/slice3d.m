function res = slice3d(obj, dir, index)
% Extract a 3D slice from a 3D image.
%
%   S = slice3d(IMG, DIR, INDEX)
%   DIR is 1, 2 or 3 for x, y or z direction respectively, and INDEX is the
%   slice index, 1-indexed, between 1 and size(IMG, DIR).
%
%   The result SLICE is a 3D Image, with the dimension DIR having only one
%   element. Use the "squeeze" method to convert to a 2D image.
%
%   Example
%     % extract a slice approximately in the middle of the brain
%     img = Image.read(analyze75info('brainMRI.hdr'));
%     sli = slice3d(img, 3, 13);
%     sli = squeeze(sli);
%     show(sli);
%
%   See also
%     slice, squeeze
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRAE - Cepia Software Platform.

% parse axis, and check bounds
dir = parseAxisIndex(dir);

name = createNewName(obj, '%s-slice');
switch dir
    case 1
        % x-slice: rows Z, cols Y
        res = Image('Data', obj.Data(index,:,:,:,:), 'Dimension', 3, 'Parent', obj, 'Name', name);
    case 2
        % y-slice: rows Z, cols X
        res = Image('Data', obj.Data(:,index,:,:,:), 'Dimension', 3, 'Parent', obj, 'Name', name);
    case 3
        % Z-slice: rows Y, cols X
        res = Image('Data', obj.Data(:,:,index,:,:), 'Dimension', 3, 'Parent', obj, 'Name', name);
    otherwise
        error('Should specify direction between 1 and 3');
end

