function img = ones(varargin)
% Creates a new image filled with ones.
%
%   IMG = Image.ones(NX, NY)
%   IMG = Image.ones(NX, NY, NZ)
%   IMG = Image.ones(DIM)
%   IMG = Image.ones(..., TYPE)
%
%   Example
%    I = Image.ones([5 3], 'uint8');
%      ans =
%       3×5 uint8 matrix
%          1   1   1   1   1
%          1   1   1   1   1
%          1   1   1   1   1
%
%   See also
%     Image, create, zeros
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-09-29,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.

% determine image dimension
inds = cellfun(@isnumeric, varargin);
dim = [varargin{inds}];

% determin image data type
type = 'double';
if any(~inds)
    type = varargin{~inds};
end

% create new image
img = Image.create(dim, type);
img.Data(:) = 1;
