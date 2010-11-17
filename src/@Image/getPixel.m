function p = getPixel(this, x, y, varargin)
% Returns a pixel in an image
% P = IMG.getPixel(X, Y)
% X is column index, Y is row index, both 1-indexed.
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% get z index if present
indz = 1;
if ~isempty(varargin)
    indz = varargin{1};
end

p = this.data(x, y, indz, :, :);
   