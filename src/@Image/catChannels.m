function res = catChannels(obj, varargin)
% Channel concatenation of several images.
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
% e-mail: david.legland@inra.fr
% Created: 2011-11-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

data = obj.Data;
name = obj.Name;

for i = 1:length(varargin)
    var = varargin{i};    
    data = cat(4, data, var.Data);
    
    name = strcat(name, '+', var.Name);
end

res = Image(...
    'data', data, ...
    'parent', obj, ...
    'type', 'vector', ...
    'name', name);
