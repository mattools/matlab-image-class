function res = jointHistogram(obj1, obj2, varargin)
% Joint histogram of two images.
%
%   JHIST = jointHistogram(I1, I2);
%   I1 and I2 are two images with the same size, JHIST is a 256-by-256
%   image containing number of pixels for each combination of values.
%
%   Example
%     % Compute joint histogram on two channels of a color image
%     img = Image.read('peppers.png');
%     histoRG = jointHistogram(channel(img, 1), channel(img, 2));
%     figure; show(log(histoRG+1)); colormap jet;
%
%   See also
%     histogram
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-11-25,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - Cepia Software Platform.


% check input dimensions
if sum(size(obj1) ~= size(obj2)) > 0
    error('Inputs must have same size');
end

% default is no ROI (use the whole pixels in images)
roi = ones(size(obj1));

% default number of intervals for computing values
q1 = 256;
q2 = 256;

% compute maximum gray values of each image
if isinteger(obj1.Data)
    maxVal1 = intmax(class(obj1.Data));
else
    maxVal1 = max(obj1.Data(:));
end
if isinteger(obj2.Data)
    maxVal2 = intmax(class(obj2.Data));
else
    maxVal2 = max(obj2.Data(:));
end

% init to empty array
vals1 = [];

% check if a ROI is specified
if ~isempty(varargin) 
    var1 = varargin{1};
    if ndims(var1) == ndims(obj1) && sum(size(obj1) ~= size(var1)) == 0
        roi = varargin{1};
        varargin(1) = [];
    end
end

% extract user-specified number of bins, or bin values
if length(varargin)==1
    var = varargin{1};
    if length(var)==1
        q1 = var;
        q2 = var;
    else
        vals1 = var;
        vals2 = var;
    end
elseif length(varargin)==2
    var1 = varargin{1};
    var2 = varargin{2};
    if length(var1)==1 && length(var2)==1
        q1 = var1;
        q2 = var2;
    else
        vals1 = var1;
        vals2 = var2;
    end
end

% compute grayscale limits if needed
if isempty(vals1)
    vals1 = linspace(0, double(maxVal1)+1, q1+1);
    vals2 = linspace(0, double(maxVal2)+1, q2+1);
    vals1(end) = [];
    vals2(end) = [];
end

% initialize result array
res = zeros(length(vals1), length(vals2));

% linear indices of pixels to consider
inds = find(roi);

if q1==256 && q2==256 && maxVal1==255 && maxVal2 == 255
    % Standard case: iterate over all pixels, use true value
    for i = 1:length(inds)
        % get each value, and convert to index
        v1 = obj1.Data(inds(i)) + 1;
        v2 = obj2.Data(inds(i)) + 1;
        
        % increment corresponding histogram
        res(v1, v2) = res(v1, v2)+1;
    end
else
    % More generic case: iterate over all pixels, find indices of first
    % bins greater than each value
    for i = 1:length(inds)
        % get each value, and convert to index
        v1 = find(obj1.Data(inds(i))>=vals1, 1, 'last');
        v2 = find(obj2.Data(inds(i))>=vals2, 1, 'last');

        % increment corresponding histogram
        res(v1, v2) = res(v1, v2)+1;
    end
end

% create new image
res = Image('Data', res, ...
    'Name', 'JointHistogram', ...
    'AxisNames', {obj1.Name, obj2.Name});
