function res = closing(this, varargin)
%CLOSING Morphological closing of an image
%
%   See Also
%     opening, erosion, dilation, blackTopHat

% process data buffer, using Matlab Image processing Toolbox
data = imclose(this.getBuffer(), varargin{:});

% create new image object for storing result
res = Image.create(data, 'parent', this);
