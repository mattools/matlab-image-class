function val = computeSumOfSSDValue(images, points)
%computeSumOfSSDValue Sum up SSD computed beteen all couple of images
%
%   SSSD = computeSumOfSSDValue(IMAGES, POINTS)
%   IMAGES is a cell array containing instances of ImageFunction (like
%   ImageInterpolator or BackwardTransformedImage).
%   POINTS is a N-by-2 or N-by-3 array of point coordinates, used for
%   computing SSD between two images.


% extract number of images
nImages = length(images);

% generate all possible couples of images
combis  = sortrows(combnk(1:nImages, 2));
nCombis = size(combis, 1);

% compute SSD for each couple
res = zeros(nCombis, 1);
for i=1:nCombis
    i1 = combis(i,1);
    i2 = combis(i,2);
    
    res(i) = computeSSDMetric(images{i1}, images{i2}, points);
end

% sum of SSD computed over couples
val = sum(res);
