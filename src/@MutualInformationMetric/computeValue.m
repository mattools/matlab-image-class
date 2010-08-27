function [mi isInside] = computeValue(this)
%COMPUTEVALUE Compute metric value
%
% [VALUE INSIDE] = METRIC.computeValue();
% Computes and return the value. Returns also a flag that indicates
% which test points belong to both images.
%

% compute values in image 1
[values1 inside1] = this.img1.evaluate(this.points);

% compute values in image 2
[values2 inside2] = this.img2.evaluate(this.points);

% keep only valid values
isInside = inside1 & inside2;

% reference for computiung histograms.
% TODO: replace by class field
x = 0:255;

% use eventually different arrays for each image
vals1 = x;
vals2 = x;

% compute base histograms
hist1   = hist(values1(isInside), vals1);
hist2   = hist(values2(isInside), vals2);

% initialize array for joint histogram
hist12  = zeros(length(vals1), length(vals2));

inds = find(isInside);
for i=1:length(inds)
    % get each value, and convert to index
    v1 = find(values1(inds(i))>=vals1, 1, 'last');
    v2 = find(values2(inds(i))>=vals2, 1, 'last');
    
    % increment corresponding histogram
    hist12(v1, v2) = hist12(v1, v2)+1;
end

% compute entropies
h1  = histogramEntropy(hist1);
h2  = histogramEntropy(hist2);
h12 = histogramEntropy(hist12);

% compute mutual information
mi = h1 + h2 - h12;

% negates to have minimum for best matching
mi = -mi;

    function h = histogramEntropy(hist)
        % inner function that computes entropy from an histogram (1D or 2D)
        
        % remove zero values
        hist(hist==0) = [];
        hist = hist / sum(hist(:));
        
        % compute entropy
        h = -sum(hist.*log(hist));
    end

end