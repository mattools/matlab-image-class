function bin = maxEntropyThreshold(img, varargin)
% Apply threshold on input image using maximisation of entropies.
%
%   BIN = maxEntropyThreshold(IMG)
%   Computes the binary segmentation of input image IMG using maximisation
%   of entropy of histogram in each class.
%
%   Example
%   % Compute threshold for coins image
%     img = Image.read('coins.png');
%     figure; show(img);
%     bin = maxEntropyThreshold(img);
%     figure; show(bin);
%
%
%   See also
%     binarize, otsuThreshold, maxEntropyThresholdValue
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-02-02,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2020 INRA - Cepia Software Platform.


% computes threshold value
value = maxEntropyThresholdValue(img, varargin{:});

% threshold image
bin = img > value;
bin.Name = ['maxEntropyThreshold(' img.Name ')'];
