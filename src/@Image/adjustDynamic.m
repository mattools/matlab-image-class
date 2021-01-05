function res = adjustDynamic(obj, varargin)
% Rescales gray levels of image to get better dynamic.
%
%   RES = adjustDynamic(IMG, [GMIN GMAX]);
%   all values below GMIN will be set to 0, all values greater than GMAX
%   will be set to 255, all values in between will be equally spaced
%   between 0 and 255.
%   The result is a 255 uint8 grayscale image.
%
%   RES = adjustDynamic(IMG, ALPHA);
%   Adjust dynamic by saturating a proportion of ALPHA image element. ALPHA
%   should be comprised between 0 and 1. ALPHA=0 will use min and max value
%   in image. 
%
%   RES = adjustDynamic(IMG);
%   Adjust image dynamic by saturating 1% of the image element.
%
%   RES = adjustDynamic(..., TYPE);
%   Specifies another type for output image. TYPE can be 'double', 'int16',
%   'uint16'... 
%
%
%   Example
%     % read "pout" image and adjust its contrast
%     img = Image.read('pout.tif');
%     img2 = adjustDynamic(img, .01);
%     figure;
%     subplot(121); show(img);
%     subplot(122); show(img2);
%
%     img3 = adjustDynamic(img, .01, 'double') / 255;
%     figure; show(img3, []);
%
%   See Also:
%     imadjust, mat2gray
%

%   ---------
%   author: David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 21/03/2005.
%

%   HISTORY
%   2005-03-25 correct bug, due to computation with unsigned values
%   2009-08-21 extends to manage double images
%   2011-11-05 rename from imRescale to adjustDynamic
%   2011-11-25 includes to Image class


%% Default values

outMin = 0;
outMax = 255;

outputClass = 'uint8';


%% process input arguments

if ~isempty(varargin)
    % use min and max values given as parameter
    var = varargin{1};
    if length(var) == 1
        [mini, maxi] = computeGrayscaleAdjustement(obj.Data, var);
    else
        mini = var(1);
        maxi = var(2);
    end
    varargin(1) = [];
    
else
    % use min and max values computed from input image, by saturating 1
    % percent of image elements
    [mini, maxi] = computeGrayscaleAdjustement(obj.Data, .01);
end

% check if a class cast is specified
if ~isempty(varargin)
    outputClass = varargin{1};
end


%% Compute grayscale adjustment

% compute slope of linear transformation
a = double((outMax - outMin) / (maxi - mini));

% compute result image
res = (obj.Data - mini) * a + outMin;

% cast to output type
res = cast(res, outputClass);

% create resulting Image
name = createNewName(obj, '%s-adjDyn');
res = Image('Data', res, 'Parent', obj, 'Name', name);


function [mini, maxi] = computeExtremeValues(data) %#ok<DEFNU>
% compute min and max (finite) values in image

mini = min(data(isfinite(data)));
maxi = max(data(isfinite(data)));

% If the difference is too small, use default range check
if abs(maxi - mini) < 1e-12
    warning('Image:adjustDynamic', ...
        'could not determine grayscale extent from data');
    mini = 0;
    maxi = 1;
end

function [mini, maxi] = computeGrayscaleAdjustement(data, alpha)
% compute grayscale range that maximize vizualisation

% use default value for alpha if not specified
if nargin == 1
    alpha = .01;
end

% sort values that are valid (avoid NaN's and Inf's)
values = sort(data(isfinite(data)));
n = length(values);

% compute values that enclose (1-alpha) percents of all values
mini = values( floor((n-1) * alpha/2) + 1);
maxi = values( floor((n-1) * (1-alpha/2)) + 1);

% small control to avoid mini==maxi
minDiff = 1e-12;
if abs(maxi - mini) < minDiff
    % use extreme values in image
    mini = values(1);
    maxi = values(end);
    
    % if not enough, set range to [0 1].
    if abs(maxi - mini) < minDiff
        mini = 0;
        maxi = 1;
    end
end

% avoid rounding effects
mini = double(mini);
maxi = double(maxi);
