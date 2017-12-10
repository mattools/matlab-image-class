function res = squeeze(this)
%SQUEEZE Remove singleton spatial dimensions of an image
%
%   output = squeeze(input)
%
%   Example
%   squeeze
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-12-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

keepDims = find(this.dataSize(1:3) ~= 1);
removeDims = find(this.dataSize(1:3) == 1);

res = Image('data', permute(this.data, [keepDims removeDims 4 5]), ...
    'parent', this, 'dimension', length(keepDims));
res.type = this.type;