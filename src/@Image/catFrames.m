function res = catFrames(this, varargin)
%CATFRAMES  Frame concatenation of several images
%
%   RES = catFrames(IMG1, IMG2)
%
%   Example
%     % 'manual' creation of a movie image
%     img = Image.read('cameraman.tif');
%     res = catFrames(img, img, invert(img));
%     show(res);
%
%   See also
%     splitFrames, cat, catChannels
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

data = this.data;
name = this.name;

for i = 1:length(varargin)
    var = varargin{i};    
    data = cat(5, data, var.data);
    
    name = strcat(name, '+', var.name);
end

res = Image(this.dimension, ...
    'data', data, ...
    'parent', this, ...
    'name', name);
