function [bin, value] = otsuThreshold(img, varargin)
% Threshold the image using Otsu method.
%
%   BIN = otsuThreshold(IMG)
%   Automatically computes threshold for segmenting image IMG, based on
%   Otsu's method, and returns the binary result.
%
%   [BIN, VALUE] = otsuThreshold(IMG)
%   Also returns the threshold value.
%
%   ... = otsuThreshold(IMG, ROI)
%   Computes Otsu threshold using pixels in the given Region of interest.
%   ROI is a binary image the same size as the input image.
%   
%
%   Example
%     % Compute binarised coins image
%     img = Image.read('coins.png');
%     figure; show(img);
%     bin = otsuThreshold(img);
%     figure; show(bin);
%
%   Note
%   Only implemented for grayscale image coded on uint8.
%
%
%   See also
%     histogram, otsuThresholdValue, lt, le
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-01-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% computes threshold value
value = otsuThresholdValue(img, varargin{:});

% threshold image
bin = img > value;
