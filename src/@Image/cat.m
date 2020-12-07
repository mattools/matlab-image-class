function res = cat(dim, obj, varargin)
% Concatenate images along specified dimension.
%
%   RES = cat(DIM, IMG1, IMG2)
%
%   Example
%     % duplicate image in horizontal direction
%     img = Image.read('cameraman.tif');
%     res = cat(1, img, img);
%     show(res);
%
%   See also
%     vertcat, horzcat, repmat, catChannels
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

data = obj.Data;

for i = 1:length(varargin)
    var = varargin{i};    
    data = cat(dim, data, var.Data);
end

res = Image('data', data, 'Parent', obj);
