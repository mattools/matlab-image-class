function res = erosion(this, varargin)
%EROSION Morphological erosion of an image

% process data buffer, using Matlab Image processing Toolbox
data = imerode(this.getBuffer(), varargin{:});

% create new image object for storing result
res = Image.create(data, 'parent', this);
