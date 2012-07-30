function res = killBorders(this, varargin)
%KILLBORDERS Remove borders of a binary or grayscale image
%
%   RES = killBorders(IMG)
%   RES = killBorders(IMG, CONN)
%   
%
%   Example
%     % Select rice grains within image
%     img = Image.read('rice.png');
%     bin = whiteTopHat(img, ones(50, 50)) > 50;
%     bin2 = killBorders(bin);
%     show(overlay(img, bin2))
%
%   See also
%     geodesicReconstruction, attributeOpening, areaOpening
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-09-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% default connectivity
conn = 4;
if ndims(this) == 3
    conn = 8;
end

% case of connectivity specified by user
if ~isempty(varargin)
    conn = varargin{1};
end

% call matlab function
newData = imclearborder(this.data, conn);

% create resulting image
res = Image('data', newData, 'parent', this);
