function res = fillHoles(this, varargin)
%FILLHOLES  Fill holes in a binary image
%
%   RES = fillHoles(IMG)
%
%   Example
%     img = Image.read('circles.png');
%     show(fillHoles(img))
%
%   See also
%     geodesicReconstruction, imfill
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% % error check
% if ~strcmp(this.type, 'binary')
%     error('Input image must be binary');
% end

% default connectivity
conn = 4;
if ndims(this) == 3
    conn = 6;
end

% parse input connectivity
if ~isempty(varargin)
    conn = varargin{1};
end

% compute new data
newData = imfill(this.data, conn, 'holes');

% create resulting image
res = Image('data', newData, 'parent', this);
