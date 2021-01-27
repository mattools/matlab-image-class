function res = orthogonalProjection(obj, dir, opName)
% Project image intensities along one of the main directions..
%
%   PROJ = orthogonalProjection(IMG, DIR, OP)
%   Project the intensities of the image IMG in the direction given by DIR.
%   The operation OP applied on the values can be one of 'Max' (default),
%   'Min', or 'Mean'.
%
%   Example
%     img = Image.read('mri.tif');
%     projXY = orthogonalProjection(img, 3, 'Mean');
%     figure; show(projXY);
%
%   See also
%     slice, min, max, mean
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2021-01-27,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE.

if strcmpi(opName, 'max')
    data = max(obj.Data, [], dir);
elseif strcmpi(opName, 'min')
    data = min(obj.Data, [], dir);
elseif strcmpi(opName, 'mean')
    data = mean(obj.Data, dir);
else
    error('Unknown operation name: %s', opName)
end

% create projected image
newName = createNewName(obj, '%s-proj');
res = Image('Data', data, 'Parent', obj, 'Name', newName);
        