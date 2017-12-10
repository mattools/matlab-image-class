function [res, inds] = areaOpening(this, value, varargin)
%AREAOPENING Remove small regions or particles in binary or label image
%
%   IMG2 = areaOpening(IMG, MINSIZE);
%   Removes the particles in image IMG that have less than MINSIZE pixels
%   or voxels. IMG can be either a bianry or a label image. If IMG is
%   binary, it is first labelled using 4 or 6 connectivity.
%
%   IMG2 = areaOpening(IMG, MINSIZE, CONN);
%   Applies to
%
%   Example
%     % Apply area opening on segmented rice image
%     img = Image.read('rice.png');
%     seg = whiteTopHat(img, ones(30, 30)) > 50;
%     seg2 = areaOpening(seg, 100);
%     figure;
%     subplot(1, 2, 1); show(seg); title('segmented');
%     subplot(1, 2, 2); show(seg2); title('after area opening');
%
%     % Area opening on text image
%     BW = Image.read('text.png');
%     BW2 = areaOpening(BW, 50);
%     figure; show(BW);
%     figure; show(BW2);
% 
%   See also
%   attributeOpening, largestRegion, regionprops, bwareaopen, opening
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

if isLabelImage(this)
    data = this.data;
    
elseif isBinaryImage(this)
    % if image is binary compute labeling
    
    % first determines connectivity to use
    conn = 4;
    if this.dimension == 3
        conn = 6;
    end
    if ~isempty(varargin)
        conn = varargin{1};
    end
    
    % appply labeling, get result as 2D or 3D matrix
    data = labelmatrix(bwconncomp(this.data, conn));
    
else
    error('Image:areaOpening', 'Requires binary or label image');
end

% compute area of each region
props = regionprops(data, 'Area');
areas = [props.Area];

% select regions with areas greater than threshold
inds = find(areas >= value);
data = ismember(data, inds);

% create new image
res = Image.create('data', data, 'parent', this, 'type', 'binary');
