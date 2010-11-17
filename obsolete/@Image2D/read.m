function img = read(fileName, varargin)
%READ Reads a planar image from a file
%
%   IMG = Image2D.read(FILENAME)
%
%   Example
%   img = Image2D.read('cameraman.tif');
%
%   See also
%   Image3D/read, imread
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-07-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

data = imread(fileName);
img = Image2D(data);
