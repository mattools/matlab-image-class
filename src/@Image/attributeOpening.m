function [res, inds] = attributeOpening(this, att, op, val, varargin)
%ATTRIBUTEOPENING Filter regions on a size or shape criterium
%
%   BIN = attributeOpening(IMG, ATT, OP, VAL)
%   Applies attribute opening on the binary or label image IMG. 
%
%   Example
%   % Apply area opening on text image
%     img = Image.read('text.png');
%     res = attributeOpening(img, 'Area', @gt, 10);
%     show(res);
%
%   See also
%     areaOpening, largestRegion, killBorders, largestRegion, regionprops
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-07-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% in case of binary image, compute labels
if isBinaryImage(this)
    lbl = labelmatrix(bwconncomp(this.data, varargin{:}));
elseif isLabelImage(this)
    lbl = this.data;
else
    error('Image:attributeOpening', 'Requires binary or label image');
end

% compute attribute for each label
props = regionprops(lbl, att);
props = [props.(att)];

% apply attribute filtering
res = feval(op, props, val);

% convert to indices
inds = find(res);

% convert result to binary image
bin = ismember(lbl, inds);

% create new image
res = Image.create('data', bin, 'parent', this, 'type', 'binary');