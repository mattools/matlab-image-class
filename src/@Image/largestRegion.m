function [res, indMax] = largestRegion(obj, varargin)
% Keep the largest region in a binary or label image.
% 
%   REG = largestRegion(LBL)
%   Finds the largest region in label image LBL, and returns the binary
%   image corresponding to obj label. Can be used to select automatically
%   the most proeminent region in a segmentation or labelling result.
%
%   [REG, IND] = largestRegion(LBL)
%   Also returns the index of the largest region.
%
%   REG = largestRegion(BIN)
%   REG = largestRegion(BIN, CONN)
%   Finds the largest connected region in the binary image IMG. A connected
%   component labelling of the image is performed prior to the
%   identification of the largest label. The connectivity can be specified.
%
%   Example
%     % Find the binary image corresponding to the largest label
%     lbl = Image.create([...
%         1 1 0 2 2 2 ;...
%         1 0 0 0 2 2 ;...
%         0 3 0 2 2 0 ;...
%         0 3 3 0 0 0 ;...
%         0 0 0 0 4 0]);
%     big = largestRegion(lbl)
%     big = 
%         0   0   0   1   1   1 
%         0   0   0   0   1   1 
%         0   0   0   1   1   0 
%         0   0   0   0   0   0 
%         0   0   0   0   0   0
%
%   % Keep the largest region in a binary image
%     BW = Image.read('text.png');
%     BW2 = largestRegion(BW, 4);
%     figure; show(overlay(BW, BW2));
% 
%   % Keep the largest region in the result of a binary segmentation
%     img = Image.read('rice.png');
%     bin = whiteTopHat(img, ones(30, 30)) > 50;
%     bin2 = largestRegion(bin, 4);
%     show(overlay(img, bin2));
%
%   See also
%     regionprops, killBorders, areaOpening, componentLabeling, 
%     regionElementCounts
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2012-07-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

if isLabelImage(obj)
    lbl = obj.Data;
    
elseif isBinaryImage(obj)
    % if image is binary compute labeling
    
    % choose default connectivity depending on dimension
    conn = defaultConnectivity(obj);
    
    % case of connectivity specified by user
    if ~isempty(varargin)
        conn = varargin{1};
    end
    
    % appply labeling, get result as 2D or 3D matrix
    lbl = labelmatrix(bwconncomp(obj.Data, conn));
    
else
    error('Image:largestRegion', 'Requires binary or label image');
end

% compute area of each label
nLabels = max(lbl(:));
areas = zeros(nLabels, 1);
for i = 1:nLabels
    areas(i) = sum(sum(sum(lbl==i)));
end

% find index of largest regions
[dum, indMax] = max(areas); %#ok<ASGLU>

% keep as binary
bin = lbl == indMax;

% create result image
name = createNewName(obj, '%s-largestRegion');
res = Image.create('Data', bin, 'Parent', obj, 'Type', 'binary', 'Name', name);
