function labels = findLabels(obj)
% Find unique labels in a label image.
%
%   Deprecated: renamed as findRegionLabels
%
%   output = findLabels(input)
%
%   Example
%   findLabels
%
%   See also
%     unique
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-07-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

warning('deprecated, use ''findRegionLabels'' instead');

% test special case of binary image based on image type
if isBinaryImage(obj)
    labels = 1;
    return;
end

if ~isLabelImage(obj)
    error('Requires a label image');
end

% special case of CC structure, not used at the moment
% if isstruct(img) && isfield(img, 'NumObjects')
%     labels = (1:img.NumObjects)';
%     return;
% end

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
    