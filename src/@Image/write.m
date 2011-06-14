function write(this, filename, varargin)
%WRITE Write image into specified file
%
%   output = write(input)
%
%   Example
%   write
%
%   See also
%   Image/read
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-06-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% assumes format can be managed by Matlab Image Processing
imwrite(permute(this.data, [2 1 3 4 5]), filename, varargin{:});
