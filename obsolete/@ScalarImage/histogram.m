function varargout = histogram(this, varargin)
%HISTOGRAM  Histogram of a scalar image
%
%   Usage 
%   H = histogram(IMG);
%   histogram(IMG);
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
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-01-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% HISTORY
% 2010-09-10 code cleanup, update doc
% 2010-09-28 integrate to oolip library


%% Initialise default parameters

% compute intensity bounds, based either on type or on image data
if isinteger(this.data)
    type = class(this.data);
    minimg = intmin(type);
    maximg = intmax(type);
else
    minimg = this.min();
    maximg = this.min();
end

% default number of histogram bins
N = 256;

% default roi is empty
roi = [];


%% Process inputs 

% process each argument
while ~isempty(varargin)
    var = varargin{1};
    
    if isempty(var)
        % if an empty variable is given, assumes gray level bounds must be
        % recomputed from image values
        minimg = this.min();
        maximg = this.max();
    elseif isnumeric(var) && length(var)==1
        % argument is number of bins
        N = var;
    elseif isnumeric(var) && length(var)==2
        % argument is min and max of values to compute
        minimg = var(1);
        maximg = var(2);
    elseif islogical(var)
        % argument is a ROI
        roi = permute(var, [2 1 3:ndims(var)]);
    elseif isnumeric(var)
        % argument is value for histo bins
        x = double(var);
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

% process 2D or 3D grayscale image
h = calcHistogram(this.data, x, roi);


%% Process output arguments

% In case of no output argument, display the histogram
if nargout==0
    % display histogram in current axis
    
    % Display grayscale histogram
    bar(gca, x, h, 'hist');
    % use jet color to avoid gray display
    colormap jet;
    
    % setup histogram bounds
    xlim([minimg maximg]);
    
elseif nargout==1
    % return histogram
    varargout = {h};
elseif nargout==2
    % return histogram and x placement
    varargout = {h, x};
end


%% Utilitary functions

function h = calcHistogram(img, x, roi)
% Compute image histogram using specified bins, and eventually a region of
% interest
if isempty(roi)
    % histogram of whole image
    h = hist(double(img(:)), x);
else
    % histogram constrained to ROI
    h = hist(double(img(roi)), x);
end    


