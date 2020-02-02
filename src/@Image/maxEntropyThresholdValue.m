function [value, maxEntropy] = maxEntropyThresholdValue(obj, varargin)
% Compute value for segmenting image using max-entropy.
%
%   V = maxEntropyThresholdValue(IMG)
%   Computes the value for segmenting the image IMG into two classes, by
%   maximizing the entropy of the histograms.
%   Note: implemented only for 256-gray level images
%
%   Example
%   % Compute threshold for coins image
%     img = Image.read('coins.png');
%     figure; show(img);
%     T = maxEntropyThresholdValue(img);
%     figure; show(img > T);
%
%   See also
%     maxEntropyThreshold, otsuThresholdValue
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2020-02-02,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2020 INRA - Cepia Software Platform.

% compute frequency histogram
histo = histogram(obj, varargin{:})';
freq = histo / sum(histo);

% allocate arrays. Compute entropy of each class and sum of entropies, for
% each possible threshold values 
H1 = zeros(256, 1);
H2 = zeros(256, 1);
psi = zeros(256, 1);

% compute total entropy
Hn = 0;
for i = 1:256
    if freq(i) ~= 0
        Hn = Hn - freq(i) * log(freq(i));
    end
end

% compute sum of entropies for each threshold level
for s = 1:256
    % compute total frequencies for each part
    P1 = sum(freq(1:s));
    P2 = sum(freq(s+1:end));

    % do not process degenerate cases 
    if P1 == 0 || P2 == 0
        continue;
    end
    
    Hs = 0;
    for i = 1:s
        if freq(i) ~= 0
            Hs = Hs - freq(i) * log(freq(i));
        end
    end
    
    % entropy of each class
    H1(s) = log(P1) + Hs / P1;
    H2(s) = log(P2) + (Hn - Hs) / P2;

    % total entropy
    psi(s) = H1(s) + H2(s);
end

% find index giving maximum of entropy
[maxEntropy, ind] = max(psi);

% convert to gray level
value = ind - 1;
