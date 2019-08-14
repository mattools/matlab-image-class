function siz = getDataSize(obj)
% Return the size of the data buffer.
%
%   SIZ = getDataSize(img)
%   SIZ is a 1-by-5 row vector, containing, in obj order:
%   SIZ(1) is the number of columns (X dimension)
%   SIZ(2) is the number of rows (Y dimension)
%   SIZ(3) is the number of slices (Z dimension)
%   SIZ(4) is the number of channels (C)
%   SIZ(5) is the number of frames (Time dimension)
%
%   Example
%   img = Image2D.read('cameraman.tif');
%   img.getDataSize()
%   ans =
%       256 256 1 1 1
%
%   See also
%     getDimension, getPhysicalExtent
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

siz = obj.DataSize;
