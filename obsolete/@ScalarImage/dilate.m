function res = dilate(this, varargin)
%DILATE Computes morphological dilation of image

% process data buffer, using Matlab Image processing Toolbox
data = imdilate(this.getBuffer(), varargin{:});

% create new image object for storing result
res = Image.create(data, 'parent', this);
