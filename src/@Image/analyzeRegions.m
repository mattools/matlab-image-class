function props = analyzeRegions(this, varargin)
%ANALYZEREGIONS compute region properties on a label or binary image
%
%   PROPS = analyzeRegions(IMG)
%
%   Example
%     % analyze regions on coins image
%     I = Image.read('coins.png');
%     bin = opening(I > 80, ones(3, 3));
%     lbl = labeling(bin);
%     props = analyzeRegions(lbl)
%     props = 
%       10x1 struct array with fields:
%         Area
%         Centroid
%         BoundingBox
%     % Display image with disc centroids overlaid (require MatGeom toolbox)
%     figure; show(I);
%     hold on;
%     drawPoint(reshape([props.Centroid]', [2 10])')
%
%
%   See also
%     regionprops
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2017-11-15,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.

if ~(isLabelImage(this) || isBinaryImage(this))
    error('Requires a label of binary image');
end

buffer = getBuffer(this);
props = regionprops(buffer, varargin{:});
