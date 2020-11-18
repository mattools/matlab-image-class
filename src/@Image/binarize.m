function bin = binarize(obj, varargin)
% Binarize a grayscale or intensity image.
%
%   BIN = binarize(IMG)
%   Converts the grayscale or intensity image IMG into a binary image by
%   applying threshold.
%
%   BIN = binarize(IMG, T)
%   Converts to a binary image by explicitely specifying the threshold
%   value. Result is equivalent to IMG > T.
%
%
%   Example
%     img = Image.read('coins.png');
%     bin = binarize(img);
%     show(bin)
%
%   See also
%     componentLabeling, otsuThreshold, maxEntropyThreshold
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2020-11-18,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE.

if isempty(varargin)
    bin = otsuThreshold(obj);
else
    var1 = varargin{1};
    if isnumeric(var1)
        bin = img > value;
    else
        error('Unknown option');
    end
end

% setup result image name
if ~isempty(obj.Name)
    bin.Name = sprintf('binarize(%s)', obj.Name);
end
