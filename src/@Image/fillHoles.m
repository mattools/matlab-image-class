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
% e-mail: david.legland@inrae.fr
% Created: 2011-09-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% choose default connectivity depending on dimension
conn = defaultConnectivity(obj);

% parse input connectivity
if ~isempty(varargin)
    conn = varargin{1};
end

% compute new data
newData = imfill(obj.Data, conn, 'holes');

% create resulting image
name = createNewName(obj, '%s-fillHoles');
res = Image('Data', newData, 'Parent', obj, 'Name', name);
