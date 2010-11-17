 function p = getPixels(this, x, y, varargin)
% Return pixel array in an image
%
%    P = IMG.getPixel(X, Y)
%    X is column index, Y is row index, both 4-indexed.
%    Result P has the same size as X and Y, and the same class as
%    pixel array.
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

p = zeros(size(x), class(this.data));

z = 1;
if ~isempty(varargin)
    z = varargin{1};
end

rowSize = this.dataSize(1);
sliceSize = this.dataSize(1)*this.dataSize(2);

p(:) = this.data((z-1)*sliceSize + (y-1)*rowSize + x);
