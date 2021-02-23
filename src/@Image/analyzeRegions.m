function props = analyzeRegions(obj, varargin)
% Compute region properties on a 2D/3D label or binary image.
%
%   TAB = analyzeRegions(IMG)
%   Returns a set of properties measured on each region of the input label
%   image IMG. The input image may be 2D or 3D.
%   The results is given as a table.
%
%   Example
%     % analyze regions on coins image
%     I = Image.read('coins.png');
%     bin = opening(I > 80, ones(3, 3));
%     lbl = componentLabeling(bin);
%     tab = analyzeRegions(lbl)
%     tab = 
%       10x3 table
%         Area        Centroid                  BoundingBox           
%         ____    ________________    ________________________________
% 
%         2609    148.54    34.446    119.5      6.5       59       56
%         1934    56.067     49.75     30.5     25.5       51       48
%         2646    216.93     70.66    187.5     42.5       59       56
%         1878    110.03    84.855     84.5     61.5       51       47
%         2750    37.071    106.69      6.5     77.5       61       58
%         1946    265.78    102.61    240.5     78.5       51       48
%         2697    174.78    119.85    144.5     91.5       60       57
%         2774    96.199    145.88     65.5    116.5       61       58
%         1979    235.95    173.16    210.5    148.5       51       49
%         2857    120.21    208.48     89.5    178.5       62       60
%
%     % Display image with disc centroids overlaid (require MatGeom toolbox)
%     figure; show(I);
%     hold on;
%     drawPoint(reshape([tab.Centroid]', [2 10])')
%
%
%   See also
%     regionprops, regionCentroids, regionBoxes, regionEquivalentEllipses
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2017-11-15,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2017 INRA - Cepia Software Platform.

if ~(isLabelImage(obj) || isBinaryImage(obj))
    error('Requires a label of binary image');
end

buffer = getBuffer(obj);
nd = ndims(obj);
if nd == 2
    props = regionprops('table', buffer, varargin{:});
elseif nd == 3
    props = regionprops3(buffer, varargin{:});
else
    error('Image:analyzeRegions', 'Can not manage images with dimension %d', nd);
end
