function res = dilation(this, varargin)
%DILATION Morphological dilation of an image

% process data buffer, using Matlab Image processing Toolbox
data = imdilate(this.getBuffer(), varargin{:});

% create new image object for storing result
res = Image.create(data, 'parent', this);
