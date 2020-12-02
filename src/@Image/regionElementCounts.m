function [counts, labels] = regionElementCounts(obj, varargin)
% Count the number of pixels/voxels within each region of a label image.
%
%   output = regionElementCounts(input)
%
%   Example
%   regionElementCounts
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-12-02,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.

% check input type
if ~isLabelImage(obj)
    error('Requires a label image as input');
end

% determine labels
if isempty(varargin)
    labels = unique(obj.Data(:));
    labels(labels==0) = [];
else
    labels = varargin{1};
end

% allocate memory
nLabels = length(labels);
counts = zeros(nLabels, 1);

% iterate over labels and count elements
for i = 1:nLabels
    counts(i) = sum(obj.Data(:) == labels(i));
end
