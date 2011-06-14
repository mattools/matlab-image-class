function n = numel(this)
%NUMEL Number of elements (pixels or voxels) in image
%
%   N = numel(IMG)
%
%   Example
%   img = Image.read('peppers.png');
%   numel(img)
%   ans =
%       196608
%
%   prod(size(img))
%   ans =
%       196608
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

n = prod(this.dataSize(1:3));
