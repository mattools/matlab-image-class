function res = catChannels(this, varargin)
%CATCHANNELS  Channel concatenation of several images
%
%   RES = catChannels(IMG1, IMG2)
%
%   Example
%     % 'manual' creation of a color image
%     img = Image.read('cameraman.tif');
%     res = catChannels(img, img, invert(img));
%     res.type = 'color';
%     show(res);
%
%   See also
%     splitChannels, cat, catFrames
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
    data = cat(4, data, var.data);
    
    name = strcat(name, '+', var.name);
end

res = Image(this.dimension, ...
    'data', data, ...
    'parent', this, ...
    'type', 'vector', ...
    'name', name);
