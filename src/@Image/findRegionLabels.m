function labels = findRegionLabels(obj)
% Find unique region labels within a label or binary image.
%
%   LABELS = findRegionLabels(IMG)
%
%   Example
%     img = Image.read('coins.png');
%     bin = fillHoles(img > 100);
%     lbl = componentLabeling(bin);
%     labels = findRegionLabels(lbl)'
%     labels =
%          1     2     3     4     5     6     7     8     9    10
%
%   See also
%     regionCentroids, unique
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2018-07-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

% test special case of binary image based on image type
if isBinaryImage(obj)
    labels = 1;
    return;
end

if ~isLabelImage(obj)
    error('Requires a label image');
end

if isinteger(obj.Data)
    % For integer images, iterates over possible labels
    
    % allocate memory
    maxLabel = double(max(obj.Data(:)));
    labels = zeros(maxLabel, 1);
    
    % iterate over possible labels
    nLabels = 0;
    for i = 1:maxLabel
        if any(obj.Data(:) == i)
            nLabels = nLabels + 1;
            labels(nLabels) = i;
        end
    end
    
    % trim label array
    labels = labels(1:nLabels);
    
else
    % use generic processing for floating-point images
    labels = unique(obj.Data(:));
    labels(labels==0) = [];
end
    