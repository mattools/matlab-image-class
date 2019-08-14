function res = squeeze(obj)
% Remove singleton spatial dimensions of an image.
%
%   RES = squeeze(IMG)
%
%   Example
%   squeeze
%
%   See also
%     permute, size
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

keepDims = find(obj.DataSize(1:3) ~= 1);
removeDims = find(obj.DataSize(1:3) == 1);

res = Image('data', permute(obj.Data, [keepDims removeDims 4 5]), ...
    'parent', obj, 'dimension', length(keepDims));
res.Type = obj.Type;