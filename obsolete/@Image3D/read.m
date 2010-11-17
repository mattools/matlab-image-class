function img = read(fileName, varargin)
%READ Reads a 3D image from a file
%
%   output = read(input)
%
%   Example
%   read
%
%   See also
%   Image2D/read, imread
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


data = readstack(fileName, varargin{:});
img = Image3D(data);

