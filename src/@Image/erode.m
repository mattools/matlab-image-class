function res = erode(this, varargin)
%ERODE Computes morphological erosion of image

% process data buffer, using Matlab Image processing Toolbox
data = imerode(this.getBuffer(), varargin{:});

% create new image object for storing result
res = Image.create(data, 'parent', this);
