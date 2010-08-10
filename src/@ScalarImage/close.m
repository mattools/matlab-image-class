function res = close(this, varargin)
%CLOSE Computes morphological closing of image

% process data buffer, using Matlab Image processing Toolbox
data = imclose(this.getBuffer(), varargin{:});

% create new image object for storing result
res = Image.create(data, 'parent', this);
