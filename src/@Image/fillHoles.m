function res = fillHoles(obj, varargin)
% Fill holes in a binary or grascale image.
%
%   RES = fillHoles(IMG)
%
%   Example
%     img = Image.read('circles.png');
%     show(fillHoles(img))
%
%   See also
%     reconstruction, killBorders, imfill
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-09-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% default connectivity
conn = 4;
if ndims(obj) == 3
    conn = 6;
end

% parse input connectivity
if ~isempty(varargin)
    conn = varargin{1};
end

% compute new data
newData = imfill(obj.Data, conn, 'holes');

% create resulting image
res = Image('data', newData, 'parent', obj);
