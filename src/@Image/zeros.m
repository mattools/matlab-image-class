function img = zeros(varargin)
% Creates a new image filled with zeros.
%
%   IMG = Image.ZEROS(NX, NY)
%   IMG = Image.ZEROS(NX, NY, NZ)
%   IMG = Image.ZEROS(DIM)
%   IMG = Image.ZEROS(..., TYPE)
%
%   Example
%     I = Image.zeros([5 3], 'uint8');
%     getBuffer(I0)
%       ans =
%         3x5 uint8 matrix
%          0   0   0   0   0
%          0   0   0   0   0
%          0   0   0   0   0
% 
%
%   See also
%     create, ones
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
img.Data(:) = 0;
