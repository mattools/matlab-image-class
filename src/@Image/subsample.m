function res = subsample(this, k, varargin)
%Create a new image by keeping one pixel over k in each direction
%
% Usage
% IMG2 = IMG.subsample(K);
% IMG2 = subsample(IMG, K);
% K is the sampling factor. It can be either a scalar, or a row vector with
% as many columns as the number of dimensions of image.
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-04-20,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.


%% Initialisations

% image dimension
ndim = getDimension(this);

% allow either scalar factor, or factor depending on dim
if isscalar(k)
    k = k(1, ones(1, ndim));
end

% get coordinate of first pixel
origin = ones(1, ndim);
if ~isempty(varargin)
    origin = varargin{1};
end


%% Subsampling of image buffer

% size of original buffer
dim = size(this.data);

% compute indices of pixels within original buffer
subsArray = cell(1, ndim);
for i=1:ndim
    subsArray{i} = origin(i):k(i):dim(i);
end

% create new image with subsampled buffer
res = Image.create('data', this.data(subsArray{:}), 'parent', this);


%% Post-processing

% update calibration
res.spacing = this.spacing .* k;
