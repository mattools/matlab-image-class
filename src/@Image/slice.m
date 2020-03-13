function res = slice(obj, index)
% Extract a XY slice from a 3D image.
%
%   S = slice(IMG, INDEX)
%   INDEX is the slice index, 1-indexed, between 1 and size(IMG, 3).
%
%   The result SLICE is a 2D Image.
%
%   Example
%     % extract a slice approximately in the middle of the brain
%     img = Image.read(analyze75info('brainMRI.hdr'));
%     sli = slice(img, 13);
%     show(sli);
%
%   See also
%     slice3d
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2010-06-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRAE - Cepia Software Platform.

% Z-slice: rows Y, cols X
res = Image('data', obj.Data(:,:,index,:,:), 'parent', obj);

