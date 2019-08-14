function res = catFrames(obj, varargin)
% Frame concatenation of several images.
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
% e-mail: david.legland@inra.fr
% Created: 2011-11-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

data = obj.Data;
name = obj.Name;

for i = 1:length(varargin)
    var = varargin{i};    
    data = cat(5, data, var.Data);
    
    name = strcat(name, '+', var.Name);
end

res = Image(...
    'data', data, ...
    'parent', obj, ...
    'name', name);
