function labels = findLabels(this)
%FINDLABELS Find unique labels in a label image
%
%   output = findLabels(input)
%
%   Example
%   findLabels
%
%   See also
%     unique
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-07-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

% test special case of binary image based on image type
if isBinaryImage(this)
    labels = 1;
    return;
end

if ~isLabelImage(this)
    error('Reqsuires a label image');
end

% special case of CC structure, not used at the moment
% if isstruct(img) && isfield(img, 'NumObjects')
%     labels = (1:img.NumObjects)';
%     return;
% end

if isinteger(this.data)
    % For integer images, iterates over possible labels
    
    % allocate memory
    maxLabel = double(max(this.data(:)));
    labels = zeros(maxLabel, 1);
    
    % iterate over possible labels
    nLabels = 0;
    for i = 1:maxLabel
        if any(this.data(:) == i)
            nLabels = nLabels + 1;
            labels(nLabels) = i;
        end
    end
    
    % trim label array
    labels = labels(1:nLabels);
    
else
    % use generic processing for floating-point images
    labels = unique(this.data(:));
    labels(labels==0) = [];
end
    