function varargout = histogram(this, varargin)
%HISTOGRAM Histogram of an Image (2D or 3D, Grayscale or Color)
%
%   Usage 
%   H = histogram(IMG);
%   H = IMG.histogram();
%   histogram(IMG);
%   IMG.histogram();
%
%   Description
%   H = histogram(IMG);
%   Compute the histogram of the image IMG. IMG can be a 2D or 3D image.
%   The number of bins is computed automatically depending on image type
%   for integer images, and on image min/max values for floating-point
%   images.
%   If IMG is a color image, the result is a N-by-3 array, containing
%   histograms for the red, green and blue bands in each column.
%
%   H = histogram(..., N);
%   Specifies the number of histogram bins. N must be a scalar>0.
%
%   H = histogram(..., [GMIN GMAX]);
%   Specifies the gray level extents. This can e especially useful for
%   images stored in float, or for images with more than 256 gray levels.
%
%   H = histogram(..., []);
%   Forces the function to compute the histogram limits from values of
%   image gray levels.
%
%   H = histogram(..., BINS);
%   Specifies the bin centers.
%
%   H = histogram(..., ROI);
%   where ROI is a binary image the same size as IMG, computes the
%   histogram only for pixels/voxels located inside of the specified region
%   of interest.
%
%   [H X] = histogram(...);
%   Returns the center of bins used for histogram computation.
%
%   histogram(IMG);
%   When called with no output argument, displays the histogram on the 
%   current axis.
%
%
%   Examples
%   % Histogram of a grayscale image (similar to imhist)
%     img = imread('cameraman.tif');
%     histogram(img);
%
%   % RGB Histogram of a color image
%     img = imread('peppers.png');
%     histogram(img);
%
%   % Compute histogram of a 3D image, only for pixel with non null values
%   % (requires image processing toolbox)
%     info = analyze75info('brainMRI.hdr');
%     X = analyze75read(info);
%     histogram(X, X>0, 0:88)
%
%   See also
%   imhist, hist
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-11-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Initialise default parameters

% default number of histogram bins
N = 256;

% default roi is empty
roi = [];

% check if image is vector
vectorImage = size(this.data, 4)>1;

% physical dimension of image
imgSize = getSize(this);

% compute intensity bounds, based either on type or on image data
if isinteger(this.data)
    type = class(this.data);
    minimg = intmin(type);
    maximg = intmax(type);
else
    minimg = min(this.data(:));
    maximg = max(this.data(:));
end


%% Process input arguments

% process each argument
while ~isempty(varargin)
    var = varargin{1};
    
    if isempty(var)
        % if an empty variable is given, assumes gray level bounds must be
        % recomputed from image values
        minimg = min(this.data(:));
        maximg = max(this.data(:));
        
    elseif isnumeric(var) && length(var)==1
        % argument is number of bins
        N = var;
        
    elseif isnumeric(var) && length(var)==2
        % argument is min and max of values to compute
        minimg = var(1);
        maximg = var(2);
        
    elseif islogical(var)
        % argument is a ROI
        roi = var;
        
        % compute roi physical size
        roiSize = size(roi);
        if vectorImage && length(roiSize)>length(imgSize)
            roiSize(3) = [];
        end
        
        % check roi size
        if sum(roiSize~=imgSize)>0
            error('ROI and image must have same size');
        end
        
    elseif isnumeric(var)
        % argument is value for histogram bins
        x = var;
        minimg = var(1);
        maximg = var(end);
        N = length(x);
    end
    
    % remove processed argument from the list
    varargin(1) = [];
end

% compute bin centers if they were not specified
if ~exist('x', 'var')
    x = linspace(double(minimg), double(maximg), N);
end


%% Main processing 

% number of channels (equal to 1 in the case of grayscale image)
nc = getChannelNumber(this);

% compute image histogram
if ~vectorImage
    % process 2D or 3D grayscale image
    h = computeDataHistogram(this.data, x, roi);
    
else
    % process vector image: compute histogram of each channel
    h = zeros(length(x), nc);
    
    % Compute histogram of each channel
    for i=1:nc
        h(:, i) = computeDataHistogram(this.data(:,:,:,i), x, roi);
    end
end


%% Process output arguments

% In case of no output argument, display the histogram
if nargout==0
    % display histogram in current axis
    if ~vectorImage
        % Display grayscale histogram
        bar(gca, x, h, 'hist');
        % use jet color to avoid gray display
        colormap jet;
        
    elseif nc==3
        % display each color histogram as stairs, to see the 3 curves
        hh = stairs(gca, x, h);
        
        % setup curve colors
        set(hh(1), 'color', [1 0 0]); % red
        set(hh(2), 'color', [0 1 0]); % green
        set(hh(3), 'color', [0 0 1]); % blue
        
    else
        % if nc is different from 3, assumes this is a spectral image, and
        % display each histogram using the HSV colormap
        map = hsv(nc);
        hh = stairs(gca, x, h);
        
        % setup curve colors
        for i = 1:nc
            set(hh(i), 'color', map(i,:));
        end
    end
    
    % setup histogram bounds
    xlim([minimg maximg]);
    
elseif nargout==1
    % return histogram
    varargout = {h};
elseif nargout==2
    % return histogram and x placement
    varargout = {h, x};
elseif nargout==3
    % return red, green and blue histograms as separate outputs
    varargout = {h(:,1), h(:,2), h(:,3)};
elseif nargout==4
    % return red, green and blue histograms as separate outputs as well as
    % the bin centers
    varargout = {h(:,1), h(:,2), h(:,3), x};
end


%% Utilitary functions

function h = computeDataHistogram(img, x, roi)
% Compute image histogram using specified bins, and eventually a region of
% interest

if isempty(roi)
    % histogram of whole image
    h = hist(double(img(:)), x)';
else
    % histogram constrained to ROI
    h = hist(double(img(roi)), x)';
end    
